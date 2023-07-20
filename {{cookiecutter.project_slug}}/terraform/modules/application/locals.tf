locals {
  common_tags = merge(var.tags, {
    automation          = "terraform"
    "automation.config" = join(".", [var.application, var.environment])
    application         = var.application
    environment         = var.environment
  })
}
