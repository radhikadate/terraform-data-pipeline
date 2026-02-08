variable "redshift_workgroup_name" {
  description = "Name of the Redshift workgroup"
  type        = string
}

variable "redshift_database_name" {
  description = "Name of the Redshift database"
  type        = string
}

variable "redshift_secret_arn" {
  description = "ARN of the Redshift credentials secret"
  type        = string
}

variable "redshift_role_arn" {
  description = "ARN of the Redshift IAM role for S3 access"
  type        = string
}

variable "s3_source_path" {
  description = "S3 path for source CSV files (e.g., s3://bucket/path/)"
  type        = string
}

variable "target_table" {
  description = "Target Redshift table name"
  type        = string
  default     = "manifest"
}

variable "autocopy_job_name" {
  description = "Name of the auto-copy job"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-2"
}

variable "schema_dependency" {
  description = "Dependency on schema creation"
  type        = any
  default     = null
}

variable "s3_notification_dependency" {
  description = "Dependency on S3 notification and policy configuration"
  type        = any
  default     = null
}
