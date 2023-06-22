# this needs to be run first
# in order to create the remote state for terraform
module "global_variables" {
  source = "../modules/global_variables"
}

provider "aws" {
  region = module.global_variables.aws_region
  assume_role {
    role_arn = "arn:aws:iam::${module.global_variables.account_id}:role/OrganizationAccountAccessRole"
  }
}

terraform {
  required_version = ">= 1.4"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${module.global_variables.application}-terraform-state"
  tags = {
    Name = "S3 Remote Terraform State Store"
  }
}

resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_state" {
  name           = "${module.global_variables.application}-terraform-state"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    "Name" = "DynamoDB Terraform State Lock Table"
  }
}
