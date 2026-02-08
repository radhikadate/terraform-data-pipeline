output "manifest_table_created" {
  description = "Indicates manifest table has been created"
  value       = module.redshift_schema.schema_applied
}

output "autocopy_configured" {
  description = "Indicates auto-copy has been configured"
  value       = module.redshift_autocopy.autocopy_job_id
}
