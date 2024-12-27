module "cluster_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = var.cluster_name
  description = "Allow all intra-cluster and egress traffic"
  vpc_id      = module.vpc.vpc_id
  tags        = local.common_tags

  ingress_with_self = [
    {
      rule = "all-all"
    },
  ]

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 6443
      to_port     = 6443
      protocol    = "tcp"
      cidr_blocks = var.admin_allowed_ips
      description = "Kubernetes API Access"
    },
{% if cookiecutter.operating_system == "talos" %}
    {
      from_port   = 50000
      to_port     = 50000
      protocol    = "tcp"
      cidr_blocks = var.admin_allowed_ips
      description = "Talos API Access"
    },
{%- elif cookiecutter.operating_system == "k3s" %}
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.admin_allowed_ips
      description = "Talos API Access"
    },
{%- endif %}
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}
