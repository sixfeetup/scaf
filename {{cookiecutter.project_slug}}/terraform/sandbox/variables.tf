variable "domain" {
  type    = string
  default = "sandbox.{{ cookiecutter.domain_name }}"
}

variable "api_domain" {
  type    = string
  default = "sandbox.api.{{ cookiecutter.domain_name }}"
}

variable "environment" {
  default = "sandbox"
}