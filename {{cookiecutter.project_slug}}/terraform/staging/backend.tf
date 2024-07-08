terraform {
  required_version = ">= 1.4"
  backend "s3" {
    region         = "{{ cookiecutter.aws_region }}"
    bucket         = "{{ cookiecutter.project_dash }}-terraform-state"
    key            = "{{ cookiecutter.project_dash }}.staging.json"
    encrypt        = true
    dynamodb_table = "{{ cookiecutter.project_dash }}-terraform-state"
  }
}
