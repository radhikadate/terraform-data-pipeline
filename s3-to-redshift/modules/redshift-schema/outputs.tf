output "schema_applied" {
  description = "Indicates schema has been applied"
  value       = null_resource.create_schema.id
}
