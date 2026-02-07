output "table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.orders.name
}

output "table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.orders.arn
}

output "table_stream_arn" {
  description = "ARN of the DynamoDB table stream"
  value       = aws_dynamodb_table.orders.stream_arn
}
