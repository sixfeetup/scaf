provider "aws" {
  region = var.aws_region
}

# us-east-1 is the only region that supports ACM certificates
provider "aws" {
  region = "us-east-1"
  alias  = "us_east_1"
}

# each environment has has a unique key to isolate state per environment
# to isolate environments completely, it is recommended to have a separate AWS
# sub-account per envionment
terraform {
  required_version = ">= 1.4"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    region         = var.aws_region
    bucket         = "${var.app_name}-terraform-state"
    key            = "${var.app_name}-${var.environment}.cluster.json"
    encrypt        = true
    dynamodb_table = "${var.app_name}-terraform-state"
  }
}

