# S3 to Redshift Auto-Copy Pipeline

Event-driven pipeline that automatically loads CSV files from S3 into Redshift using S3 integrations and auto-copy jobs.

## Architecture

```
S3 (file upload)
  → S3 Event Notification
  → Redshift Integration
  → Auto-Copy Job
  → Redshift (loads data)
```

## Resources Created

- **S3 Bucket Policy**: Grants Redshift service access to S3 bucket
- **Redshift Resource Policy**: Allows S3 integration creation
- **S3 Integration**: Connects S3 bucket to Redshift namespace
- **Redshift Schema**: Creates `manifest` table
- **Auto-Copy Job**: Monitors S3 and automatically loads new files

## Prerequisites

- Static infrastructure deployed (`static-setup/`)
- S3 bucket with CSV files in `manifest/` prefix
- Redshift Serverless namespace and workgroup

## Deployment

```bash
cd s3-to-redshift
cp terraform.tfvars.example terraform.tfvars
# Update with values from static-setup outputs
terraform init
terraform plan
terraform apply
```

## How It Works

1. **Upload CSV file to S3**:
   ```bash
   aws s3 cp data.csv s3://pp-manifest-{account_id}-{region}/manifest/
   ```

2. **S3 event notification** triggers via the integration

3. **Auto-copy job** automatically loads the file into Redshift `manifest` table

4. **Verify data**:
   ```bash
   aws redshift-data execute-statement \
     --workgroup-name pp-dev-workgroup \
     --database dev \
     --sql "SELECT COUNT(*) FROM manifest;" \
     --region ap-southeast-2
   ```

## Important Notes

- Auto-copy only processes **new files** uploaded after job creation
- Existing files in S3 need to be re-uploaded to trigger loading
- CSV files must have headers (IGNOREHEADER 1 is used)
- Integration takes ~30 seconds to become active after creation

## Cleanup

```bash
terraform destroy
```

This removes:
- Auto-copy job
- S3 integration
- Redshift resource policy
- S3 bucket policy

Note: The `manifest` table and data are preserved.
