resource "aws_s3_bucket" "manifest" {
  bucket = "pp-manifest-${var.account_id}-${var.region}"

  tags = {
    Name        = "pp-manifest-bucket"
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "glue_assets" {
  bucket = "pp-glue-assets-${var.account_id}-${var.region}"

  tags = {
    Name        = "pp-glue-assets"
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket = "pp-cloudtrail-logs-${var.account_id}-${var.region}"

  tags = {
    Name        = "pp-cloudtrail-logs"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "cloudtrail_logs" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}
