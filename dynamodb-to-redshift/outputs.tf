output "glue_job_name" {
  description = "Name of the Glue job"
  value       = module.glue_job.job_name
}

output "glue_role_arn" {
  description = "ARN of the Glue IAM role"
  value       = module.iam_roles.glue_role_arn
}

output "step_function_arn" {
  description = "ARN of the Step Functions state machine"
  value       = module.step_function.state_machine_arn
}

output "eventbridge_rule_name" {
  description = "Name of the EventBridge rule"
  value       = module.eventbridge_rule.rule_name
}
