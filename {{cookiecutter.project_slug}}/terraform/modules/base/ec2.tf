data "aws_ami" "talos" {
  owners      = ["540036508848"] # Sidero Labs
  most_recent = true
  name_regex  = "^talos-v\\d+\\.\\d+\\.\\d+-${data.aws_availability_zones.available.id}-amd64$"
}

locals {
  cluster_required_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

module "control_plane_nodes" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.6.1"

  count = var.control_plane.num_instances

  name                        = "${var.cluster_name}-${count.index}"
  ami                         = var.control_plane.ami_id == null ? data.aws_ami.talos.id : var.control_plane.ami_id
  monitoring                  = true
  instance_type               = var.control_plane.instance_type
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
  subnet_id                   = element(module.vpc.public_subnets, count.index)
  iam_role_use_name_prefix    = false
  create_iam_instance_profile = false
  tags                        = merge(local.common_tags, local.cluster_required_tags)

  vpc_security_group_ids = [module.cluster_sg.security_group_id]
}

