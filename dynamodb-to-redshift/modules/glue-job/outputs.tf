output "job_name" {
  description = "Name of the Glue job"
  value       = aws_glue_job.dynamodb_to_redshift.name
}

output "job_arn" {
  description = "ARN of the Glue job"
  value       = aws_glue_job.dynamodb_to_redshift.arn
}
