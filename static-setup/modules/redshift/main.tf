resource "aws_redshiftserverless_namespace" "main" {
  namespace_name      = "pp-${var.environment}-namespace"
  admin_username      = var.admin_username
  admin_user_password = var.admin_password
  db_name             = var.database_name

  tags = {
    Name        = "pp-${var.environment}-namespace"
    Environment = var.environment
  }
}

resource "aws_redshiftserverless_workgroup" "main" {
  namespace_name = aws_redshiftserverless_namespace.main.namespace_name
  workgroup_name = "pp-${var.environment}-workgroup"
  base_capacity  = var.base_capacity

  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids

  publicly_accessible = false

  tags = {
    Name        = "pp-${var.environment}-workgroup"
    Environment = var.environment
  }
}
