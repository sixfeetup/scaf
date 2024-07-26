{% if cookiecutter.create_nextjs_frontend == "y" %}
module "ecr_frontend" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "1.6.0"

  repository_name                 = var.frontend_ecr_repo
  repository_image_tag_mutability = "MUTABLE"

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 5 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 5
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = local.common_tags
}
{% endif %}

module "ecr_backend" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "1.6.0"

  repository_name                 = var.backend_ecr_repo
  repository_image_tag_mutability = "MUTABLE"

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 5 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 5
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = local.common_tags
}
