resource "aws_s3_object" "glue_script" {
  bucket = var.glue_assets_bucket
  key    = "scripts/pp-${var.environment}-dynamodb-to-redshift.py"
  source = "${path.module}/script/dynamodb-to-redshift.py"
  etag   = filemd5("${path.module}/script/dynamodb-to-redshift.py")

  tags = {
    Name        = "pp-${var.environment}-glue-script"
    Environment = var.environment
  }
}

resource "aws_glue_job" "dynamodb_to_redshift" {
  name     = "pp-${var.environment}-dynamodb-to-redshift"
  role_arn = var.glue_role_arn

  command {
    name            = "pythonshell"
    script_location = "s3://${var.glue_assets_bucket}/${aws_s3_object.glue_script.key}"
    python_version  = "3.9"
  }

  default_arguments = {
    "--job-language"                  = "python"
    "--enable-job-insights"           = "false"
    "--enable-observability-metrics"  = "false"
    "--enable-glue-datacatalog"       = "true"
    "--additional-python-modules"     = "boto3>=1.34.0"
    "--TempDir"                       = "s3://${var.glue_assets_bucket}/temporary/"
    "--DYNAMODB_TABLE_NAME"           = var.dynamodb_table_name
    "--REDSHIFT_WORKGROUP"            = var.redshift_workgroup_name
    "--REDSHIFT_DATABASE"             = var.redshift_database_name
    "--REDSHIFT_SECRET_ARN"           = var.redshift_secret_arn
  }

  max_capacity = 0.0625
  timeout      = 2880
  glue_version = "3.0"

  tags = {
    Name        = "pp-${var.environment}-dynamodb-to-redshift"
    Environment = var.environment
  }
}
