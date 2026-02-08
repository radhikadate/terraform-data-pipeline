variable "glue_role_arn" {
  description = "ARN of the IAM role for Glue job"
  type        = string
}

variable "glue_assets_bucket" {
  description = "Name of the S3 bucket for Glue assets"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
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

variable "environment" {
  description = "Environment (dev, test, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Environment must be dev, test, or prod."
  }
}
