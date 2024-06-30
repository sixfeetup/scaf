locals {
  common_tags = merge(var.tags, {
    automation          = "terraform"
    "automation.config" = join(".", [var.app_name, var.environment])
    application         = var.app_name
    environment         = var.environment
  })
}
