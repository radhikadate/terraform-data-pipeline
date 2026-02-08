output "state_machine_arn" {
  description = "ARN of the Step Functions state machine"
  value       = aws_sfn_state_machine.glue_trigger.arn
}

output "state_machine_name" {
  description = "Name of the Step Functions state machine"
  value       = aws_sfn_state_machine.glue_trigger.name
}

output "step_function_role_arn" {
  description = "ARN of the Step Function IAM role"
  value       = aws_iam_role.step_function.arn
}
