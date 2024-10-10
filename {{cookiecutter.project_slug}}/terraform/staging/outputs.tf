output "talosconfig" {
  description = "The generated talosconfig"
  value       = module.cluster.talosconfig
  sensitive   = true
}

output "kubeconfig" {
  description = "The generated kubeconfig"
  value       = module.cluster.kubeconfig
  sensitive   = true
}

output "machineconfig" {
  description = "The generated machineconfig"
  value       = module.cluster.machineconfig
  sensitive   = true
}

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
{% if cookiecutter.mail_service == "Amazon SES" %}

output "amazon_ses_user_key" {
  value = module.cluster.amazon_ses_user_key
}

output "amazon_ses_user_secret_key" {
  sensitive = true
  value     = module.cluster.amazon_ses_user_key
}
{% endif %}

output "control_plane_nodes_public_ips" {
  description = "The public ip addresses of the talos control plane nodes"
  value       = module.cluster.control_plane_nodes_public_ips
}
