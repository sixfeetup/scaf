# generate key pair
resource "tls_private_key" "repo_key" {
  algorithm = "ED25519"
}

resource "aws_secretsmanager_secret" "repo_private_key" {
  name        = "${var.app_name}-argocd-private-key"
  description = "ArgoCD private key for ${var.app_name}"
}

resource "aws_secretsmanager_secret_version" "repo_private_key_version" {
  secret_id     = aws_secretsmanager_secret.repo_private_key.id
  secret_string = tls_private_key.repo_key.private_key_openssh
}

# output the public key
output "github_public_deploy_key" {
  value = tls_private_key.repo_key.public_key_openssh
}

# Update the Manifest with Private Key
locals {
  repo_name    = var.repo_name
  repo_url     = var.repo_url
  type_b64     = base64encode("git")
  repo_url_b64 = base64encode(local.repo_url)
  private_key  = tls_private_key.repo_key.private_key_openssh
}

data "template_file" "repo_creds" {
  template = file("${path.module}/repocreds.template.yaml")

  vars = {
    repo_name             = local.repo_name
    type_b64              = local.type_b64
    repo_url_b64          = local.repo_url_b64
    github_deploy_key_b64 = base64encode(local.private_key)
  }
}
