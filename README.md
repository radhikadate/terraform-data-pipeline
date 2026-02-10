# Terraform Data Pipeline

Event-driven data pipeline infrastructure on AWS using Terraform. Automates data flow from DynamoDB and S3 into Redshift, with scheduled exports back to S3.

## Architecture

```
DynamoDB → CloudTrail → EventBridge → Step Functions → Glue → Redshift
S3 → S3 Integration → Auto-Copy Job → Redshift
Redshift → EventBridge Scheduler → UNLOAD → S3
```

## Project Structure

```
terraform-data-pipeline/
├── static-setup/              # Foundation infrastructure
├── dynamodb-to-redshift/      # DynamoDB → Redshift pipeline
├── s3-to-redshift/            # S3 → Redshift pipeline
├── redshift-s3-unload/        # Redshift → S3 scheduled exports
└── .github/workflows/         # CI/CD pipelines
```

## Prerequisites

- AWS CLI configured
- Terraform >= 1.0
- AWS Account with appropriate permissions

## Quick Start

### 1. Deploy Static Infrastructure

```bash
cd static-setup
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform init
terraform apply
```

### 2. Deploy DynamoDB to Redshift Pipeline

```bash
cd ../dynamodb-to-redshift
terraform init
terraform apply
```

### 3. Deploy S3 to Redshift Pipeline

```bash
cd ../s3-to-redshift
terraform init
terraform apply
```

### 4. Deploy Redshift to S3 Unload

```bash
cd ../redshift-s3-unload
terraform init
terraform apply
```

## Pipelines

### Static Setup
Creates foundational infrastructure:
- VPC with public/private subnets
- Redshift Serverless (namespace + workgroup)
- S3 buckets (manifest, glue-assets, cloudtrail-logs)
- DynamoDB table with streams
- CloudTrail for event capture
- IAM roles and security groups

### DynamoDB to Redshift
Event-driven pipeline that syncs DynamoDB records to Redshift:
1. Insert into DynamoDB triggers CloudTrail event
2. EventBridge rule matches PutItem events
3. Step Function orchestrates Glue job
4. Glue job loads data into Redshift

### S3 to Redshift
Auto-copy pipeline for CSV files:
1. Upload CSV to S3 triggers event notification
2. S3 integration detects new file
3. Auto-copy job loads file into Redshift
4. Data appears in `manifest` table

### Redshift to S3 Unload
Scheduled export of Redshift data:
1. EventBridge Scheduler runs daily
2. Executes UNLOAD command on view
3. Exports data to S3 as CSV
4. Creates reconciliation reports

## Configuration

All modules use remote state to reference `static-setup` outputs. Only need to configure:

- `region` - AWS region
- `account_id` - AWS account ID
- `environment` - Environment name (dev/test/prod)

## CI/CD

### Deploy Pipeline
Automatically deploys on push to main:
```bash
git push origin main
```

### Destroy Pipeline
Manual trigger with confirmation:
1. Go to Actions → Destroy Data Pipeline
2. Type "destroy" to confirm
3. Run workflow

## Testing

### Test DynamoDB Pipeline
```bash
aws dynamodb put-item \
  --table-name pp-orders \
  --item '{"PartKey": {"S": "ORD#001"}, "status": {"S": "pending"}}' \
  --region ap-southeast-2
```

### Test S3 Pipeline
```bash
aws s3 cp data.csv s3://pp-manifest-{account}-{region}/manifest/
```

### Verify in Redshift
```sql
SELECT * FROM orders;
SELECT * FROM manifest;
SELECT * FROM v_order_manifest_summary;
```

## Key Features

- **Event-Driven**: Automatic data loading on insert/upload
- **Modular**: Independent pipelines with clear dependencies
- **Remote State**: Automatic configuration sharing between modules
- **Scheduled Exports**: Daily reconciliation reports
- **CI/CD Ready**: GitHub Actions workflows included
- **Destroy Provisioners**: Clean teardown of resources

## Cleanup

```bash
# Destroy in reverse order
cd redshift-s3-unload && terraform destroy
cd ../s3-to-redshift && terraform destroy
cd ../dynamodb-to-redshift && terraform destroy
cd ../static-setup && terraform destroy
```

Or use the GitHub Actions destroy workflow.

## Notes

- Auto-copy jobs only process new files uploaded after job creation
- Redshift tables and data persist after terraform destroy
- S3 buckets must be empty before destroy
- CloudTrail events may take 5-15 minutes to appear

## License

MIT
