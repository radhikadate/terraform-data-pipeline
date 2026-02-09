variable "environment" {
  description = "Environment name"
  type        = string
}

variable "schedule_expression" {
  description = "Schedule expression (e.g., rate(1 day) or cron(0 2 * * ? *))"
  type        = string
  default     = "rate(1 day)"
}

variable "redshift_workgroup_name" {
  description = "Redshift workgroup name"
  type        = string
}

variable "redshift_database_name" {
  description = "Redshift database name"
  type        = string
}

variable "redshift_secret_arn" {
  description = "Redshift credentials secret ARN"
  type        = string
}

variable "redshift_role_arn" {
  description = "Redshift IAM role ARN for S3 access"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name for exports"
  type        = string
}

variable "scheduler_role_arn" {
  description = "IAM role ARN for EventBridge Scheduler"
  type        = string
}
