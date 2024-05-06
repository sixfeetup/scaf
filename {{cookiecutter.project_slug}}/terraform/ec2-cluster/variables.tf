variable "admin_ip" {
  type    = string
  default = "admin_id"
}

variable "ami_id" {
  type        = string
  description = "AMI id to use in the EC2 instance, warning - will update when AMI updates"
  default     = "ami-053b0d53c279acc90"
}

# will fetch the latest ubuntu ami and store in terraform.tfvars
# change ami_id to be constant if you dont want it to change on the next release
data "aws_ami" "latest_ubuntu" {
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

variable "instance_type" {
  type    = string
  default = "t2.medium"
}

variable "app_instance" {
  type        = string
  description = "App instance"
  default     = "instance"
}

variable "path_to_public_key" {
  type    = string
  default = "~/.ssh/{{ cookiecutter.project_slug }}_default_key.pub"
}

variable "tags" {
  type = map(string)

  default = {
    automation          = "terraform"
    "automation.config" = "{{ cookiecutter.project_dash }}"
    application         = "{{ cookiecutter.project_dash }}"
  }
}

provider "http" {}

data "http" "bitbucket_ips" {
  url = "https://ip-ranges.atlassian.com/"

  request_headers = {
    Accept = "application/json"
  }
}

locals {
  bitbucket_ipv4_cidrs = [for c in jsondecode(data.http.bitbucket_ips.response_body).items : c.cidr if length(regexall(":", c.cidr)) == 0]
}

variable "max_egress_rules" {
  default = 60
}

locals {
  chunks     = chunklist(local.bitbucket_ipv4_cidrs, var.max_egress_rules)
  chunks_map = { for i in range(length(local.chunks)) : i => local.chunks[i] }
}
