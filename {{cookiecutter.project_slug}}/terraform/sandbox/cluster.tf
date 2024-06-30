module "cluster" {
  source                 = "../modules/base"
  environment            = "sandbox"
  cluster_name           = "{{ cookiecutter.project_dash }}-sandbox"
  domain_name            = "sandbox.{{ cookiecutter.domain_name }}"
  api_domain_name        = "api.sandbox.{{ cookiecutter.domain_name }}"
  cluster_domain_name    = "k8s.sandbox.{{ cookiecutter.domain_name }}"
  argocd_domain_name     = "argocd.sandbox.{{ cookiecutter.domain_name }}"
  prometheus_domain_name = "prometheus.sandbox.{{ cookiecutter.domain_name }}"
  control_plane = {
    # 2 vCPUs, 2 GiB RAM, $0.0188 per Hour
    instance_type = "t3a.small"
    num_instances = 3
    # NB!: set ami_id to prevent instance recreation when the latest ami
    # changes, eg:
    # ami_id = "ami-09d22b42af049d453"

}
