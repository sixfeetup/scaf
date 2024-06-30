module "cluster" {
  source                 = "../modules/base"
  environment            = "prod"
  cluster_name           = "{{ cookiecutter.project_dash }}-prod"
  domain_name            = "prod.{{ cookiecutter.domain_name }}"
  api_domain_name        = "api.prod.{{ cookiecutter.domain_name }}"
  cluster_domain_name    = "k8s.prod.{{ cookiecutter.domain_name }}"
  argocd_domain_name     = "argocd.prod.{{ cookiecutter.domain_name }}"
  prometheus_domain_name = "prometheus.prod.{{ cookiecutter.domain_name }}"
}
