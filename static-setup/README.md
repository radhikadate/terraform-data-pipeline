# Static Infrastructure Setup

This module provisions the foundational AWS infrastructure for the data pipeline.

## Resources Created

### Netork 
- **VPC**: for hosting the redshift serverless cluster
- **Subnets**: 2 public and 2 private subnets
- **Internet Gateway**: For internet access
- **NAT Gateways**: for private subnet internet access

### Storage 
- **S3 Buckets**:
  - `pp-manifest-{account_id}-{region}` - Store manfiest data files
  - `pp-glue-assets-{account_id}-{region}` - Table needed for glue
  - `pp-cloudtrail-logs-{account_id}-{region}` - For cloudtrail
- **DynamoDB**: `pp-orders` table with streams enabled (NEW_IMAGE)
- **Redshift Serverless**: Target data in dev database

### Security 
- **Secrets Manager**: `pp-dev-redshift-credentials` (random password)
- **IAM Role**: Redshift role (S3 + Glue access)

### Event Generation
- **CloudTrail**: `pp-dev-trail` to track dynamodb inserts.

## Prerequisites

- AWS CLI configured with credentials
- Terraform >= 1.0
- Region: <your choice>

## Deployment

```bash
cd static-setup
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

After deploying static infrastructure, proceed to:
1. `dynamodb-to-redshift/` - DynamoDB→Redshift pipeline
2. TBD
