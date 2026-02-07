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

module "vpc" {
  source = "./modules/vpc"

  environment           = var.environment
  cidr_block            = var.vpc_cidr_block
  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  availability_zone_1   = var.availability_zone_1
  availability_zone_2   = var.availability_zone_2
}

module "security_groups" {
  source = "./modules/security-groups"

  vpc_id          = module.vpc.vpc_id
  vpc_cidr_block  = module.vpc.vpc_cidr_block
  environment     = var.environment
}

module "secrets" {
  source = "./modules/secrets"

  environment = var.environment
}

module "redshift" {
  source = "./modules/redshift"

  admin_username      = module.secrets.redshift_admin_username
  admin_password      = module.secrets.redshift_admin_password
  database_name       = module.secrets.redshift_database_name
  subnet_ids          = [module.vpc.private_subnet_1_id, module.vpc.private_subnet_2_id]
  security_group_ids  = [module.security_groups.redshift_security_group_id]
  environment         = var.environment
}

module "s3" {
  source = "./modules/s3"

  account_id  = var.account_id
  region      = var.region
  environment = var.environment
}

module "dynamodb" {
  source = "./modules/dynamodb"

  environment = var.environment
}

module "cloudtrail" {
  source = "./modules/cloudtrail"

  cloudtrail_bucket_name = module.s3.cloudtrail_logs_bucket_name
  cloudtrail_bucket_id   = module.s3.cloudtrail_logs_bucket_name
  cloudtrail_bucket_arn  = module.s3.cloudtrail_logs_bucket_arn
  dynamodb_table_arn     = module.dynamodb.table_arn
  environment            = var.environment
}

module "iam_roles" {
  source = "./modules/iam-roles"

  environment = var.environment
}
