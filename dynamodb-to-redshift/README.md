# DynamoDB to Redshift Pipeline

Event-driven ETL pipeline that automatically syncs DynamoDB records to Redshift.

## Architecture

```
DynamoDB (PutItem) 
  → CloudTrail (captures event)
  → EventBridge Rule (filters PutItem)
  → Step Function (orchestrates)
  → Glue Job (ETL)
  → Redshift (inserts data)
```

## Deployment

```bash
cd dynamodb-to-redshift
cp terraform.tfvars.example terraform.tfvars
# Update with values from static-setup outputs
terraform init
terraform plan
terraform apply
```

## Workflow

1. **Insert into DynamoDB**:
   ```bash
   aws dynamodb put-item \
     --table-name pp-orders \
     --item '{"PartKey": {"S": "ORD#001"}, "status": {"S": "pending"}, "type": {"S": "online"}}' \
     --region ap-southeast-2
   ```

2. **CloudTrail** captures the PutItem API call

3. **EventBridge** rule matches the event and triggers Step Function

4. **Step Function** extracts `order_id` and starts Glue job with parameter

5. **Glue Job**:
   - Fetches the specific order from DynamoDB
   - Inserts into Redshift `orders` table

6. **Verify in Redshift**:
   ```bash
   aws redshift-data execute-statement \
     --workgroup-name pp-dev-workgroup \
     --database dev \
     --sql "SELECT * FROM orders;" \
     --region ap-southeast-2
   ```
