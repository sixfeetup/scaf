# the application module sets up Route53 records to the EC2 cluster and S3 static storage
module "application" {
  source = "../modules/application"

  application       = module.global_variables.application
  environment       = var.environment
  domain_zone       = var.domain
  cluster_domain    = var.cluster_domain
  argocd_domain     = var.argocd_domain
  cluster_public_id = data.aws_instance.ec2_cluster.public_ip
  cluster_id        = data.aws_instance.ec2_cluster.id
  cluster_arn       = data.aws_instance.ec2_cluster.arn
}