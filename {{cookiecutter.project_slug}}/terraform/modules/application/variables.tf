variable "application" {
  default = "{{cookiecutter.project_slug}}"
}

variable "environment" {
  default = "sandbox"
}

variable "domain_zone" {
  default = "{{ cookiecutter.domain_name }}"
}

variable "domain_urls" {
  type    = list(string)
  default = ["{{ cookiecutter.domain_name }}"]
}

variable "cluster_public_id" {
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}
