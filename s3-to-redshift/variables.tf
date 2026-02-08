variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-2"
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "redshift_workgroup_name" {
  description = "Name of the Redshift workgroup"
  type        = string
}

variable "redshift_database_name" {
  description = "Name of the Redshift database"
  type        = string
  default     = "dev"
}

variable "redshift_secret_arn" {
  description = "ARN of the Redshift credentials secret"
  type        = string
}

variable "redshift_role_arn" {
  description = "ARN of the Redshift IAM role"
  type        = string
}

variable "manifest_bucket_name" {
  description = "Name of the S3 manifest bucket"
  type        = string
}

variable "redshift_namespace_name" {
  description = "Name of the Redshift namespace"
  type        = string
  default     = "pp-dev-namespace"
}
