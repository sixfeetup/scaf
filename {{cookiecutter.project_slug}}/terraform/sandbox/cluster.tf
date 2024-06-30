module "cluster" {
  source = "../modules/base"

  environment            = "sandbox"
  cluster_name           = "{{ cookiecutter.project_dash }}-sandbox"
  domain_name            = "sandbox.{{ cookiecutter.domain_name }}"
  api_domain_name        = "api.sandbox.{{ cookiecutter.domain_name }}"
  cluster_domain_name    = "k8s.sandbox.{{ cookiecutter.domain_name }}"
  argocd_domain_name     = "argocd.sandbox.{{ cookiecutter.domain_name }}"
  prometheus_domain_name = "prometheus.sandbox.{{ cookiecutter.domain_name }}"
  control_plane = {
    # curl -sL https://github.com/siderolabs/talos/releases/download/v1.7.4/cloud-images.json | jq -r '.[] | select(.cloud == "aws" and .region == "us-east-1" and .arch == "amd64")'
    ami_id = "ami-04be44740c9604fa2"
    # 2 vCPUs, 2 GiB RAM, $0.0188 per Hour
    instance_type = "t3a.small"
    num_instances = 3
  }
}

module "base" {
  source = "../modules/base"
}
