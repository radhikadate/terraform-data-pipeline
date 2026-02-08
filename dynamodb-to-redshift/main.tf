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

module "iam_roles" {
  source = "./modules/iam-roles"

  environment = var.environment
}

module "redshift_schema" {
  source = "./modules/redshift-schema"

  redshift_workgroup_name = var.redshift_workgroup_name
  redshift_database_name  = var.redshift_database_name
  redshift_secret_arn     = var.redshift_secret_arn
  region                  = var.region
}

module "glue_job" {
  source = "./modules/glue-job"

  glue_role_arn           = module.iam_roles.glue_role_arn
  glue_assets_bucket      = var.glue_assets_bucket_name
  dynamodb_table_name     = var.dynamodb_table_name
  redshift_workgroup_name = var.redshift_workgroup_name
  redshift_database_name  = var.redshift_database_name
  redshift_secret_arn     = var.redshift_secret_arn
  environment             = var.environment

  depends_on = [module.redshift_schema]
}

module "step_function" {
  source = "./modules/step-function"

  glue_job_name = module.glue_job.job_name
  environment   = var.environment
}

module "eventbridge_rule" {
  source = "./modules/eventbridge-rule"

  dynamodb_table_name   = var.dynamodb_table_name
  step_function_arn     = module.step_function.state_machine_arn
  eventbridge_role_arn  = module.iam_roles.eventbridge_role_arn
  environment           = var.environment
}
