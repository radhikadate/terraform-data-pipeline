variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-2"
}

variable "environment" {
  description = "Environment (dev, test, prod)"
  type        = string
  default     = "dev"
}

variable "schedule_expression" {
  description = "Schedule expression for unload (e.g., rate(1 day) or cron(0 2 * * ? *))"
  type        = string
  default     = "rate(1 day)"
}
