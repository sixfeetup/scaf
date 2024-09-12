output "cnpg-iam-role-arn" {
  description = "CloudNativePG iam role arn"
  value       = module.cluster.cnpg-iam-role-arn
  sensitive   = false
}

output "cnpg_user_access_key" {
  value = module.cluster.cnpg_user_access_key
}

output "cnpg_user_secret_key" {
  sensitive = true
  value     = module.cluster.cnpg_user_secret_key
}

output "control_plane_nodes_public_ips" {
  description = "The public ip addresses of the talos control plane nodes"
  value       = module.cluster.control_plane_nodes_public_ips
}
