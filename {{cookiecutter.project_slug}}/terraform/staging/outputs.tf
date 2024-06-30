output "talosconfig" {
  description = "The generated talosconfig"
  value       = module.base.talosconfig
  sensitive   = true
}

output "kubeconfig" {
  description = "The generated kubeconfig"
  value       = module.base.kubeconfig
  sensitive   = true
}

output "machineconfig" {
  description = "The generated machineconfig"
  value       = module.base.machineconfig
  sensitive   = true
}

output "cnpg-iam-role-arn" {
  description = "CloudNativePG iam role arn"
  value       = module.base.cnpg-iam-role-arn
  sensitive   = false
}

output "cnpg_user_access_key" {
  value = module.base.cnpg_user_access_key
}

output "cnpg_user_secret_key" {
  sensitive = true
  value     = module.base.cnpg_user_secret_key
}

output "control_plane_nodes_public_ips" {
  description = "The public ip addresses of the talos control plane nodes"
  value       = module.base.control_plane_nodes_public_ips
}
