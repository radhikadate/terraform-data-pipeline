terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_redshiftserverless_namespace" "main" {
  namespace_name = var.redshift_namespace_name
}

module "redshift_schema" {
  source = "./modules/redshift-schema"

  redshift_workgroup_name = var.redshift_workgroup_name
  redshift_database_name  = var.redshift_database_name
  redshift_secret_arn     = var.redshift_secret_arn
  region                  = var.region
}

module "s3_notification" {
  source = "./modules/s3-notification"

  bucket_name    = var.manifest_bucket_name
  account_id     = var.account_id
  region         = var.region
  namespace_id   = data.aws_redshiftserverless_namespace.main.namespace_id
  namespace_arn  = data.aws_redshiftserverless_namespace.main.arn
  namespace_name = var.redshift_namespace_name
}

module "redshift_autocopy" {
  source = "./modules/redshift-autocopy"

  redshift_workgroup_name       = var.redshift_workgroup_name
  redshift_database_name        = var.redshift_database_name
  redshift_secret_arn           = var.redshift_secret_arn
  redshift_role_arn             = var.redshift_role_arn
  s3_source_path                = "s3://${var.manifest_bucket_name}/manifest/"
  target_table                  = "manifest"
  autocopy_job_name             = "pp_manifest_autocopy"
  region                        = var.region
  schema_dependency             = module.redshift_schema.schema_applied
  s3_notification_dependency    = module.s3_notification.policy_configured
}
