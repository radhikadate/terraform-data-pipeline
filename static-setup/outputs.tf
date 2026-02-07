output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_1_id" {
  description = "Public subnet 1 ID"
  value       = module.vpc.public_subnet_1_id
}

output "public_subnet_2_id" {
  description = "Public subnet 2 ID"
  value       = module.vpc.public_subnet_2_id
}

output "private_subnet_1_id" {
  description = "Private subnet 1 ID"
  value       = module.vpc.private_subnet_1_id
}

output "private_subnet_2_id" {
  description = "Private subnet 2 ID"
  value       = module.vpc.private_subnet_2_id
}

output "redshift_security_group_id" {
  description = "Redshift security group ID"
  value       = module.security_groups.redshift_security_group_id
}

output "glue_security_group_id" {
  description = "Glue security group ID"
  value       = module.security_groups.glue_security_group_id
}

output "redshift_secret_arn" {
  description = "Redshift credentials secret ARN"
  value       = module.secrets.redshift_secret_arn
}

output "redshift_workgroup_endpoint" {
  description = "Redshift workgroup endpoint"
  value       = module.redshift.workgroup_endpoint
}

output "redshift_namespace_id" {
  description = "Redshift namespace ID"
  value       = module.redshift.namespace_id
}

output "redshift_workgroup_id" {
  description = "Redshift workgroup ID"
  value       = module.redshift.workgroup_id
}

output "cloudtrail_trail_arn" {
  description = "CloudTrail trail ARN"
  value       = module.cloudtrail.trail_arn
}

output "redshift_role_arn" {
  description = "Redshift IAM role ARN"
  value       = module.iam_roles.redshift_role_arn
}

output "dynamodb_table_name" {
  description = "DynamoDB table name"
  value       = module.dynamodb.table_name
}

output "dynamodb_table_arn" {
  description = "DynamoDB table ARN"
  value       = module.dynamodb.table_arn
}

output "dynamodb_stream_arn" {
  description = "DynamoDB stream ARN"
  value       = module.dynamodb.table_stream_arn
}

output "manifest_bucket_name" {
  description = "Manifest S3 bucket name"
  value       = module.s3.manifest_bucket_name
}

output "glue_assets_bucket_name" {
  description = "Glue assets S3 bucket name"
  value       = module.s3.glue_assets_bucket_name
}

output "cloudtrail_logs_bucket_name" {
  description = "CloudTrail logs S3 bucket name"
  value       = module.s3.cloudtrail_logs_bucket_name
}
