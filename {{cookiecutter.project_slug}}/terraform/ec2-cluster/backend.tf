provider "aws" {
  region = module.global_variables.aws_region
  assume_role {
    role_arn = "arn:aws:iam::${module.global_variables.account_id}:role/OrganizationAccountAccessRole"
  }
}

# Storing the state file in an encrypted s3 bucket
terraform {
  required_version = ">= 1.4"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    region         = "{{cookiecutter.aws_region}}"
    bucket         = "${module.global_variables.application}-terraform-state"
    key            = "{{cookiecutter.project_slug}}.cluster.json"
    encrypt        = true
    dynamodb_table = "${module.global_variables.application}-terraform-state"
  }
}

module "global_variables" {
  source = "../modules/global_variables"
}