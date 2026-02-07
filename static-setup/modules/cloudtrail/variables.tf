variable "cloudtrail_bucket_name" {
  description = "Name of the S3 bucket for CloudTrail logs"
  type        = string
}

variable "cloudtrail_bucket_id" {
  description = "ID of the S3 bucket for CloudTrail logs"
  type        = string
}

variable "cloudtrail_bucket_arn" {
  description = "ARN of the S3 bucket for CloudTrail logs"
  type        = string
}

variable "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table to track"
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
