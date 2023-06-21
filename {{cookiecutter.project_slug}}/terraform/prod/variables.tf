variable "domain" {
  type    = string
  default = "{{ cookiecutter.domain_name }}"
}

variable "api_domain" {
  type    = string
  default = "api.{{ cookiecutter.domain_name }}"
}

variable "environment" {
  default = "prod"
}
