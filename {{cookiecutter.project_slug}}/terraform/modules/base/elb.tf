module "elb_k8s_elb" {
  source  = "terraform-aws-modules/elb/aws"
  version = "~> 4.0"

  name    = "${var.cluster_name}-k8s-api"
  subnets = module.vpc.public_subnets
  tags    = merge(local.common_tags, local.cluster_required_tags)

  security_groups = [module.cluster_sg.security_group_id]

  listener = [
    {
      lb_port           = 80
      lb_protocol       = "tcp"
      instance_port     = 30080
      instance_protocol = "tcp"
    },
    {
      lb_port           = 443
      lb_protocol       = "tcp"
      instance_port     = 30443
      instance_protocol = "tcp"
    },
    {
      lb_port           = 6443
      lb_protocol       = "tcp"
      instance_port     = 6443
      instance_protocol = "tcp"
    },
  ]

  health_check = {
    target              = "tcp:6443"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  number_of_instances = var.control_plane.num_instances
  instances           = module.control_plane_nodes.*.id
}


