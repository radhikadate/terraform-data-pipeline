variable "admin_username" {
  description = "Redshift admin username"
  type        = string
}

variable "admin_password" {
  description = "Redshift admin password"
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "Redshift database name"
  type        = string
}

variable "base_capacity" {
  description = "Base capacity in RPUs"
  type        = number
  default     = 128
}

variable "subnet_ids" {
  description = "List of subnet IDs for Redshift"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for Redshift"
  type        = list(string)
}

variable "environment" {
  description = "Environment (dev, test, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Environment must be dev, test, or prod."
  }
}
