variable "application" {
  type    = string
  default = "{{ cookiecutter.project_dash }}"
}

variable "environment" {
  type    = string
  default = "sandbox"
}

variable "domain_zone" {
  type    = string
  default = "{{ cookiecutter.domain_name }}"
}

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

variable "cluster_public_id" {
  default = ""
}

variable "cluster_id" {
  default = ""
}

variable "cluster_arn" {
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}
