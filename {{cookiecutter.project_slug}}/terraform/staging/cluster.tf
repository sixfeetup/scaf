module "cluster" {
  source                 = "../modules/base"
  environment            = "staging"
  cluster_name           = "{{ cookiecutter.project_dash }}-staging"
  domain_name            = "staging.{{ cookiecutter.domain_name }}"
  api_domain_name        = "api.staging.{{ cookiecutter.domain_name }}"
  cluster_domain_name    = "k8s.staging.{{ cookiecutter.domain_name }}"
  argocd_domain_name     = "argocd.staging.{{ cookiecutter.domain_name }}"
  prometheus_domain_name = "prometheus.staging.{{ cookiecutter.domain_name }}"
}
