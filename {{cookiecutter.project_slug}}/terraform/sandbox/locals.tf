locals {
  common_tags = {
    automation          = "terraform"
    "automation.config" = join(".", [module.global_variables.application, var.environment])
    application         = module.global_variables.application
    environment         = var.environment
  }
}
