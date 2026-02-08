output "policy_configured" {
  description = "Indicates S3 bucket policy has been configured"
  value       = aws_s3_bucket_policy.redshift_access.id
}

output "integration_created" {
  description = "Indicates S3 integration has been created"
  value       = null_resource.s3_integration.id
}
