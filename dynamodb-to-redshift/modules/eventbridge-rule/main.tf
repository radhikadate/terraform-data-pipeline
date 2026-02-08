resource "aws_cloudwatch_event_rule" "dynamodb_insert" {
  name          = "pp-${var.environment}-dynamodb-insert"
  description   = "Capture DynamoDB PutItem events via CloudTrail"
  event_pattern = jsonencode({
    source      = ["aws.dynamodb"]
    detail-type = ["AWS API Call via CloudTrail"]
    detail = {
      eventSource = ["dynamodb.amazonaws.com"]
      eventName   = ["PutItem"]
      requestParameters = {
        tableName = [var.dynamodb_table_name]
      }
    }
  })

  tags = {
    Name        = "pp-${var.environment}-dynamodb-insert"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_event_target" "step_function" {
  rule     = aws_cloudwatch_event_rule.dynamodb_insert.name
  arn      = var.step_function_arn
  role_arn = var.eventbridge_role_arn
}
