resource "null_resource" "create_autocopy_job" {
  triggers = {
    job_name                = var.autocopy_job_name
    workgroup_name          = var.redshift_workgroup_name
    database_name           = var.redshift_database_name
    secret_arn              = var.redshift_secret_arn
    region                  = var.region
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo "Waiting for S3 integration to become active..."
      sleep 30
      aws redshift-data execute-statement \
        --workgroup-name ${var.redshift_workgroup_name} \
        --database ${var.redshift_database_name} \
        --secret-arn ${var.redshift_secret_arn} \
        --sql "COPY ${var.target_table} FROM '${var.s3_source_path}' IAM_ROLE '${var.redshift_role_arn}' FORMAT AS CSV IGNOREHEADER 1 JOB CREATE ${var.autocopy_job_name} AUTO ON;" \
        --region ${var.region}
    EOT
  }

  provisioner "local-exec" {
    when = destroy
    command = <<-EOT
      aws redshift-data execute-statement \
        --workgroup-name ${self.triggers.workgroup_name} \
        --database ${self.triggers.database_name} \
        --secret-arn ${self.triggers.secret_arn} \
        --sql "COPY JOB DROP ${self.triggers.job_name};" \
        --region ${self.triggers.region} || true
    EOT
  }

  depends_on = [var.schema_dependency, var.s3_notification_dependency]
}
