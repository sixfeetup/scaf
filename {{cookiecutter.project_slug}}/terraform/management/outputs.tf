output "ecr_backend_url" {
  value = module.ecr_backend.repository_url
}

output "ecr_frontend_url" {
  value = module.ecr_frontend.repository_url
}
