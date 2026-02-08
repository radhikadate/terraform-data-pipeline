output "autocopy_job_id" {
  description = "ID of the auto-copy job"
  value       = null_resource.create_autocopy_job.id
}
