output "namespace_id" {
  description = "Redshift namespace ID"
  value       = aws_redshiftserverless_namespace.main.id
}

output "namespace_arn" {
  description = "Redshift namespace ARN"
  value       = aws_redshiftserverless_namespace.main.arn
}

output "workgroup_id" {
  description = "Redshift workgroup ID"
  value       = aws_redshiftserverless_workgroup.main.id
}

output "workgroup_arn" {
  description = "Redshift workgroup ARN"
  value       = aws_redshiftserverless_workgroup.main.arn
}

output "workgroup_endpoint" {
  description = "Redshift workgroup endpoint"
  value       = aws_redshiftserverless_workgroup.main.endpoint[0].address
}

output "workgroup_port" {
  description = "Redshift workgroup port"
  value       = aws_redshiftserverless_workgroup.main.endpoint[0].port
}
