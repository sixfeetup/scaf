# the application module sets up Route53 records to the EC2 cluster and S3 static storage
module "application" {
  source = "../modules/application"

  application       = module.global_variables.application
  environment       = var.environment
  domain_zone       = var.domain
  domain_urls       = [var.domain, var.api_domain]
  cluster_public_id = data.aws_instance.ec2_cluster.public_ip
}