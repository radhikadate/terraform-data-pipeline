resource "aws_dynamodb_table" "orders" {
  name         = "pp-orders"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "PartKey"

  attribute {
    name = "PartKey"
    type = "S"
  }

  stream_enabled   = true
  stream_view_type = "NEW_IMAGE"

  tags = {
    Name        = "pp-orders"
    Environment = var.environment
  }
}