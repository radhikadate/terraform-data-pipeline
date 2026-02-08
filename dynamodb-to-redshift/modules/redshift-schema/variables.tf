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

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-2"
}
