output "redshift_secret_arn" {
  description = "ARN of the Redshift credentials secret"
  value       = aws_secretsmanager_secret.redshift.arn
}

output "redshift_admin_username" {
  description = "Redshift admin username"
  value       = var.redshift_admin_username
}

output "redshift_admin_password" {
  description = "Redshift admin password"
  value       = random_password.redshift_admin.result
  sensitive   = true
}

output "redshift_database_name" {
  description = "Redshift database name"
  value       = var.redshift_database_name
}
