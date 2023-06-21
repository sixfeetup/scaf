############################################
# this needs to be run first 
# in order to create the remote state for terraform
resource "aws_s3_bucket" "terraform_state" {
  bucket = "{{cookiecutter.project_slug}}-state-backend"
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

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "tf_state_controls" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  depends_on = [aws_s3_bucket_ownership_controls.tf_state_controls]

  bucket = aws_s3_bucket.terraform_state.id
  acl    = "private"
}

resource "aws_dynamodb_table" "terraform_state" {
  name           = "{{cookiecutter.project_slug}}-terraform-state"
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
    bucket         = "{{cookiecutter.project_slug}}-terraform-state"
    key            = "{{cookiecutter.project_slug}}.management.json"
    encrypt        = true
    dynamodb_table = "{{cookiecutter.project_slug}}-terraform-state"
  }
}

module "global_variables" {
  source = "../modules/global_variables"
}
