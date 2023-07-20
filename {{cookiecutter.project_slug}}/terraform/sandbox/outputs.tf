output "domains" {
  value = [var.domain, var.api_domain]
}

output "ec2_cluster_public_dns" {
  value = data.aws_instance.ec2_cluster.public_dns
}

output "static_storage_domain" {
  value = module.application.static_storage_bucket
}

output "application_user_access_key" {
  value = module.application.application_user_access_key
}

output "application_user_secret_key" {
  sensitive = true
  value     = module.application.application_user_secret_key
}