data "aws_iam_role" "github_oidc_role" {
  name = "{{ cookiecutter.project_slug }}-github-oidc-role"
}

# Define the IAM policy for ECR
resource "aws_iam_policy" "ecr_push_policy" {
  name        = "${var.app_name}-${var.repo_name}-ecr-push-policy"
  description = "Policy to allow pushing images to ECR"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ],
        Resource = [
          {% if cookiecutter.create_nextjs_frontend == "y" %}"arn:aws:ecr:${var.aws_region}:${var.account_id}:repository/${var.frontend_ecr_repo}",{% endif %}
          "arn:aws:ecr:${var.aws_region}:${var.account_id}:repository/${var.backend_ecr_repo}",
        ]
      },
      {
        Effect   = "Allow",
        Action   = "ecr:GetAuthorizationToken",
        Resource = "*"
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "ecr_push_policy_attachment" {
  role       = data.aws_iam_role.github_oidc_role.name
  policy_arn = aws_iam_policy.ecr_push_policy.arn
}

