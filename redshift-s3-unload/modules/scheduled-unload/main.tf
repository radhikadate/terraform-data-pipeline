resource "aws_scheduler_schedule" "daily_unload" {
  name       = "pp-${var.environment}-daily-unload"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = var.schedule_expression

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:redshiftdata:executeStatement"
    role_arn = var.scheduler_role_arn

    input = jsonencode({
      WorkgroupName = var.redshift_workgroup_name
      Database      = var.redshift_database_name
      SecretArn     = var.redshift_secret_arn
      Sql           = "UNLOAD ('SELECT * FROM public.v_order_manifest_summary') TO 's3://${var.s3_bucket_name}/exports/manifest_recon_' IAM_ROLE '${var.redshift_role_arn}' CSV HEADER PARALLEL OFF ALLOWOVERWRITE;"
    })
  }
}
