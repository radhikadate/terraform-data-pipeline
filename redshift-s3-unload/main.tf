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

data "terraform_remote_state" "static_setup" {
  backend = "local"

  config = {
    path = "../static-setup/terraform.tfstate"
  }
}

module "iam_roles" {
  source = "./modules/iam-roles"

  environment = var.environment
}

module "redshift_view" {
  source = "./modules/redshift-view"

  redshift_workgroup_name = data.terraform_remote_state.static_setup.outputs.redshift_workgroup_id
  redshift_database_name  = "dev"
  redshift_secret_arn     = data.terraform_remote_state.static_setup.outputs.redshift_secret_arn
  region                  = var.region
}

module "scheduled_unload" {
  source = "./modules/scheduled-unload"

  environment             = var.environment
  schedule_expression     = var.schedule_expression
  redshift_workgroup_name = data.terraform_remote_state.static_setup.outputs.redshift_workgroup_id
  redshift_database_name  = "dev"
  redshift_secret_arn     = data.terraform_remote_state.static_setup.outputs.redshift_secret_arn
  redshift_role_arn       = data.terraform_remote_state.static_setup.outputs.redshift_role_arn
  s3_bucket_name          = data.terraform_remote_state.static_setup.outputs.manifest_bucket_name
  scheduler_role_arn      = module.iam_roles.scheduler_role_arn

  depends_on = [module.redshift_view]
}
