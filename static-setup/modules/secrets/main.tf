resource "random_password" "redshift_admin" {
  length  = 16
  special = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "redshift" {
  name        = "pp-${var.environment}-redshift-credentials"
  description = "Redshift admin credentials for data pipeline"

  tags = {
    Name        = "pp-${var.environment}-redshift-credentials"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "redshift" {
  secret_id = aws_secretsmanager_secret.redshift.id
  secret_string = jsonencode({
    username = var.redshift_admin_username
    password = random_password.redshift_admin.result
    database = var.redshift_database_name
  })
}
