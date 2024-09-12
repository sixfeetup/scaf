output "cnpg-iam-role-arn" {
  description = "CloudNativePG iam role arn"
  value       = aws_iam_role.ec2_role.arn
  sensitive   = false
}

output "cnpg_user_access_key" {
  value = aws_iam_access_key.cnpg_user_key.id
}

output "cnpg_user_secret_key" {
  sensitive = true
  value     = aws_iam_access_key.cnpg_user_key.secret
}

output "control_plane_nodes_public_ips" {
  description = "The public ip addresses of the talos control plane nodes."
  value       = join(",", module.control_plane_nodes.*.public_ip)
}
