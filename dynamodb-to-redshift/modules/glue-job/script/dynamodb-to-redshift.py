import sys
import boto3
from awsglue.utils import getResolvedOptions
import time

# Get job arguments
args = getResolvedOptions(sys.argv, [
    'order_id',
    'DYNAMODB_TABLE_NAME',
    'REDSHIFT_WORKGROUP',
    'REDSHIFT_DATABASE',
    'REDSHIFT_SECRET_ARN'
])

order_id = args['order_id']
dynamodb_table_name = args['DYNAMODB_TABLE_NAME']
redshift_workgroup = args['REDSHIFT_WORKGROUP']
redshift_database = args['REDSHIFT_DATABASE']
redshift_secret_arn = args['REDSHIFT_SECRET_ARN']

print(f"Processing order: {order_id}")
print(f"DynamoDB table: {dynamodb_table_name}")
print(f"Redshift workgroup: {redshift_workgroup}")

def fetch_dynamo_order(part_key, table_name):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(table_name)
    
    try:
        response = table.get_item(Key={'PartKey': part_key})
        print(response)
        if 'Item' in response:
            return response['Item']
        else:
            print(f"Order {part_key} not found.")
            return None
    except Exception as e:
        print(f"Error fetching from DynamoDB: {e}")
        raise

def insert_to_redshift(order_item, workgroup, database, secret_arn):
    redshift_data = boto3.client('redshift-data')
    
    # Insert data
    sql = f"""
        INSERT INTO orders (order_id, status, type) 
        VALUES ('{order_item['PartKey']}', '{order_item.get('status', 'unknown')}', '{order_item.get('type', 'unknown')}');
    """
    
    try:
        response = redshift_data.execute_statement(
            SecretArn=secret_arn,
            Database=database,
            Sql=sql,
            WorkgroupName=workgroup
        )
        print(f"Redshift statement submitted. ID: {response['Id']}")
        
        statement_id = response['Id']
        while True:
            desc = redshift_data.describe_statement(Id=statement_id)
            status = desc['Status']
            
            if status == 'FINISHED':
                print("Success! Data inserted into Redshift.")
                break
            elif status == 'FAILED':
                print(f"FAILED! Error: {desc.get('Error')}")
                raise Exception(f"Redshift insert failed: {desc.get('Error')}")
            elif status in ['ABORTED', 'SUBMITTED', 'PICKED', 'STARTED']:
                print(f"Current status: {status}...")
                time.sleep(4)
        
        return statement_id
    except Exception as e:
        print(f"Error inserting to Redshift: {e}")
        raise

# Main execution
data = fetch_dynamo_order(order_id, dynamodb_table_name)
print(f"Fetched data: {data}")

if data:
    insert_to_redshift(data, redshift_workgroup, redshift_database, redshift_secret_arn)
    print(f"Successfully processed order {order_id}")
else:
    print(f"No data found for order {order_id}")