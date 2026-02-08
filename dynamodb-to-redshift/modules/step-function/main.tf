resource "aws_iam_role" "step_function" {
  name = "pp-${var.environment}-stepfunction-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "states.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name        = "pp-${var.environment}-stepfunction-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy" "step_function_policy" {
  name = "pp-${var.environment}-stepfunction-policy"
  role = aws_iam_role.step_function.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "glue:*"
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

resource "aws_sfn_state_machine" "glue_trigger" {
  name     = "pp-${var.environment}-glue-trigger"
  role_arn = aws_iam_role.step_function.arn

  definition = jsonencode({
    Comment = "Trigger Glue job when DynamoDB receives PutItem"
    StartAt = "StartGlueJob"
    States = {
      StartGlueJob = {
        Type     = "Task"
        Resource = "arn:aws:states:::glue:startJobRun.sync"
        Parameters = {
          JobName = var.glue_job_name
          Arguments = {
            "--order_id.$" = "$.detail.requestParameters.key.PartKey"
          }
        }
        End = true
      }
    }
  })

  tags = {
    Name        = "pp-${var.environment}-glue-trigger"
    Environment = var.environment
  }
}
