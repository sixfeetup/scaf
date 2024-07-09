provider "aws" {
  region = var.aws_region
}

# us-east-1 is the only region that supports ACM certificates
provider "aws" {
  region = "us-east-1"
  alias  = "us_east_1"
}
