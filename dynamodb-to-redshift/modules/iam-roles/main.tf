resource "aws_iam_role" "glue" {
  name = "pp-${var.environment}-glue-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "glue.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name        = "pp-${var.environment}-glue-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "glue_service" {
  role       = aws_iam_role.glue.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy" "glue_full_access" {
  name = "pp-${var.environment}-glue-full-access"
  role = aws_iam_role.glue.id

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
        Action   = "dynamodb:*"
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = "redshift:*"
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = "redshift-data:*"
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = "secretsmanager:*"
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = "logs:*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "eventbridge" {
  name = "pp-${var.environment}-eventbridge-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "events.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name        = "pp-${var.environment}-eventbridge-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy" "eventbridge_invoke_stepfunction" {
  name = "pp-${var.environment}-eventbridge-invoke-stepfunction"
  role = aws_iam_role.eventbridge.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "states:StartExecution"
        Resource = "*"
      }
    ]
  })
}
