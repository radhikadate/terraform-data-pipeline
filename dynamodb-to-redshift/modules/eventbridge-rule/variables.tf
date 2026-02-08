variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table to monitor"
  type        = string
}

variable "step_function_arn" {
  description = "ARN of the Step Function to trigger"
  type        = string
}

variable "eventbridge_role_arn" {
  description = "ARN of the IAM role for EventBridge to invoke Step Function"
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