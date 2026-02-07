output "manifest_bucket_name" {
  description = "Name of the manifest S3 bucket"
  value       = aws_s3_bucket.manifest.id
}

output "manifest_bucket_arn" {
  description = "ARN of the manifest S3 bucket"
  value       = aws_s3_bucket.manifest.arn
}

output "glue_assets_bucket_name" {
  description = "Name of the Glue assets S3 bucket"
  value       = aws_s3_bucket.glue_assets.id
}

output "glue_assets_bucket_arn" {
  description = "ARN of the Glue assets S3 bucket"
  value       = aws_s3_bucket.glue_assets.arn
}

output "cloudtrail_logs_bucket_name" {
  description = "Name of the CloudTrail logs S3 bucket"
  value       = aws_s3_bucket.cloudtrail_logs.id
}

output "cloudtrail_logs_bucket_arn" {
  description = "ARN of the CloudTrail logs S3 bucket"
  value       = aws_s3_bucket.cloudtrail_logs.arn
}
