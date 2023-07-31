variable "application" {
  default = "{{cookiecutter.project_slug}}"
}

variable "environment" {
  default = "sandbox"
}

variable "domain_zone" {
  default = "{{ cookiecutter.domain_name }}"
}

variable "api_domain" {
  type    = string
  default = "api.{{ cookiecutter.domain_name }}"
}

variable "cluster_domain" {
  default = "k8s.{{ cookiecutter.domain_name }}"
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
