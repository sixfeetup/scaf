data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.1"

  name = var.cluster_name
  cidr = var.cluster_vpc_cidr
  tags = local.common_tags

  enable_nat_gateway = false

  map_public_ip_on_launch = true

  # lets pick utmost three AZ's since the CIDR bit is 2
  azs            = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnets = [for i, v in slice(data.aws_availability_zones.available.names, 0, 3) : cidrsubnet(var.cluster_vpc_cidr, 2, i)]
}


