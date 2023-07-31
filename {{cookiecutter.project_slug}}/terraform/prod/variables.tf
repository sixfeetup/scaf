variable "domain" {
  type    = string
  default = "{{ cookiecutter.domain_name }}"
}

variable "api_domain" {
  type    = string
  default = "api.{{ cookiecutter.domain_name }}"
}

variable "cluster_domain" {
  type    = string
  default = "k8s.{{ cookiecutter.domain_name }}"
}

variable "argocd_domain" {
  type    = string
  default = "argocd.{{ cookiecutter.domain_name }}"
}

variable "environment" {
  default = "prod"
}
