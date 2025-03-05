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
{% if cookiecutter.mail_service == "Amazon SES" %}

output "amazon_ses_user_key" {
  value = aws_iam_access_key.amazon_ses_user_key.id
}

output "amazon_ses_user_secret_key" {
  sensitive = true
  value     = aws_iam_access_key.amazon_ses_user_key.secret
}
{% endif %}

output "control_plane_nodes_public_ips" {
  description = "The public ip addresses of the control plane nodes."
  value       = join(",", module.control_plane_nodes.*.public_ip)
}

output "control_plane_nodes_private_ips" {
  description = "The private ip addresses of the control plane nodes."
  value       = join(",", module.control_plane_nodes.*.private_ip)
}

output "private_deploy_key" {
  value     = tls_private_key.deploy_key.private_key_openssh
  sensitive = true
}

output "public_deploy_key" {
  value     = tls_private_key.deploy_key.public_key_openssh
}
