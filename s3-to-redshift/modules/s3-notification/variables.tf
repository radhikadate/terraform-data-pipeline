variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "namespace_id" {
  description = "Redshift namespace ID"
  type        = string
}

variable "namespace_arn" {
  description = "Redshift namespace ARN"
  type        = string
}

variable "namespace_name" {
  description = "Redshift namespace name"
  type        = string
}
