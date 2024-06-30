terraform {
  required_version = ">= 1.4"
  backend "s3" {
    region         = "{{ cookiecutter.aws_region }}"
    bucket         = "{{ cookiecutter.project_dash }}-terraform-state"
    key            = "{{ cookiecutter.project_slug }}.sandbox.json"
    encrypt        = true
    dynamodb_table = "{{ cookiecutter.project_dash }}-terraform-state"
  }
}

module "global_variables" {
  source = "../modules/global_variables"
}
