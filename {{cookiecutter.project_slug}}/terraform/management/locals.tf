locals {
  common_tags = {
    automation          = "terraform"
    "automation.config" = module.global_variables.application
    application         = module.global_variables.application
  }
}
