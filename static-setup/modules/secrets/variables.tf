variable "redshift_admin_username" {
  description = "Redshift admin username"
  type        = string
  default     = "admin"
}

variable "redshift_database_name" {
  description = "Redshift database name"
  type        = string
  default     = "dev"
}

variable "environment" {
  description = "Environment (dev, test, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Environment must be dev, test, or prod."
  }
}
