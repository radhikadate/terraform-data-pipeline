resource "aws_iam_role" "redshift" {
  name = "pp-${var.environment}-redshift-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "redshift.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name        = "pp-${var.environment}-redshift-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy" "redshift_full_access" {
  name = "pp-${var.environment}-redshift-full-access"
  role = aws_iam_role.redshift.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:*"
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = "glue:*"
        Resource = "*"
      }
    ]
  })
}
