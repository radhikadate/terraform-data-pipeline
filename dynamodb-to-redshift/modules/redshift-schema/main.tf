resource "null_resource" "create_schema" {
  triggers = {
    schema_hash = filemd5("${path.module}/sql/orders.sql")
  }

  provisioner "local-exec" {
    command = <<-EOT
      aws redshift-data execute-statement \
        --workgroup-name ${var.redshift_workgroup_name} \
        --database ${var.redshift_database_name} \
        --secret-arn ${var.redshift_secret_arn} \
        --sql "$(cat ${path.module}/sql/orders.sql)" \
        --region ${var.region}
    EOT
  }
}
