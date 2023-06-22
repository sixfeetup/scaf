locals {
  common_tags = {
    automation          = "terraform"
    "automation.config" = "{{cookiecutter.project_slug}}"
    application         = module.global_variables.application
  }
}
