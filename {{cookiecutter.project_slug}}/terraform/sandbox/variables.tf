variable "domain" {
  type    = string
  default = "sandbox.{{ cookiecutter.domain_name }}"
}

variable "api_domain" {
  type    = string
  default = "api.sandbox.{{ cookiecutter.domain_name }}"
}

variable "cluster_domain" {
  type    = string
  default = "k8s.sandbox.{{ cookiecutter.domain_name }}"
}

variable "argocd_domain" {
  type    = string
  default = "argocd.sandbox.{{ cookiecutter.domain_name }}"
}

variable "environment" {
  default = "sandbox"
}