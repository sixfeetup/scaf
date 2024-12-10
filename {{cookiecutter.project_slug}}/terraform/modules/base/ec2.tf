{% if cookiecutter.operating_system == "talos" %}
data "aws_ami" "os" {
  owners      = ["540036508848"] # Sidero Labs
  most_recent = true
  name_regex  = "^talos-v\\d+\\.\\d+\\.\\d+-${data.aws_availability_zones.available.id}-amd64$"
}
{%- elif cookiecutter.operating_system == "k3s" %}
data "aws_ami" "os" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "null_resource" "generate_ssh_key" {
  provisioner "local-exec" {
    command = <<-EOT
      if [ ! -f ${var.path_to_deploy_key} ]; then
        mkdir -p $(dirname ${var.path_to_deploy_key})
        ssh-keygen -t rsa -b 4096 -f ${var.path_to_deploy_key} -N ''
        chmod 600 ${var.path_to_deploy_key}
      fi
    EOT
  }
}

resource "aws_key_pair" "default_key" {
  key_name   = "{{ cookiecutter.project_slug }}_default_key"
  public_key = file("${var.path_to_deploy_key}.pub")
  depends_on = [null_resource.generate_ssh_key]
}
{%- endif %}

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
  ami                         = var.control_plane.ami_id == null ? data.aws_ami.os.id : var.control_plane.ami_id
  monitoring                  = true
  instance_type               = var.control_plane.instance_type
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
  subnet_id                   = element(module.vpc.public_subnets, count.index)
  iam_role_use_name_prefix    = false
  create_iam_instance_profile = false
  tags                        = merge(local.common_tags, local.cluster_required_tags)

{%- if cookiecutter.operating_system == "k3s" %}
  key_name                    = aws_key_pair.default_key.key_name
{%- endif %}

  lifecycle {
    ignore_changes = [ami]
  }

  vpc_security_group_ids = [module.cluster_sg.security_group_id]
}

