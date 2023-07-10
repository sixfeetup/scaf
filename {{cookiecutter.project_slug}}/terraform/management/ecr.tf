module "ecr_backend" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "1.6.0"

  repository_name = "${module.global_variables.application}-backend"

  repository_read_write_access_arns = [aws_iam_user.cicd_user.arn]
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

module "ecr_frontend" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "1.6.0"

  repository_name = "${module.global_variables.application}-frontend"

  repository_read_write_access_arns = [aws_iam_user.cicd_user.arn]
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
