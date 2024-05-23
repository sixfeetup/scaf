output "ecr_backend_url" {
  value = module.ecr_backend.repository_url
}

{% if cookiecutter.create_react_frontend == 'y' %}
output "ecr_frontend_url" {
  value = module.ecr_frontend.repository_url
}

{% endif %}
output "ecr_cicd_aws_access_key_id" {
  description = "ECR AWS Access key ID"
  value       = aws_iam_access_key.cicd_user.id
}

output "ecr_cicd_aws_secret_access_key" {
  description = "ECR AWS Secret access key"
  value       = aws_iam_access_key.cicd_user.secret
  sensitive   = true
}
