module "cluster" {
  source                 = "../modules/base"
  environment            = "prod"
  cluster_name           = "{{ cookiecutter.project_dash }}-prod"
  domain_name            = "prod.{{ cookiecutter.domain_name }}"
  api_domain_name        = "api.prod.{{ cookiecutter.domain_name }}"
  cluster_domain_name    = "k8s.prod.{{ cookiecutter.domain_name }}"
  argocd_domain_name     = "argocd.prod.{{ cookiecutter.domain_name }}"
  prometheus_domain_name = "prometheus.prod.{{ cookiecutter.domain_name }}"
  control_plane = {
    # 2 vCPUs, 4 GiB RAM, $0.0376 per Hour
    instance_type = "t3a.medium"
    num_instances = 3
    # NB!: set ami_id to prevent instance recreation when the latest ami
    # changes, eg:
    # ami_id = "ami-09d22b42af049d453"
  }

  # NB!: limit admin_allowed_ips to a set of trusted
  # public ip addresses. Both variables are comma separated lists of ips.
  # admin_allowed_ips = "10.0.0.1/32,10.0.0.2/32"
}
