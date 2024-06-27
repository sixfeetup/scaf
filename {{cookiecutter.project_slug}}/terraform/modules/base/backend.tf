provider "aws" {
  region = var.aws_region
}

# us-east-1 is the only region that supports ACM certificates
provider "aws" {
  region = "us-east-1"
  alias  = "us_east_1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.app_name}-${var.environment}-terraform-state"
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
  name           = "${var.app_name}-${var.environment}-terraform-state"
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
