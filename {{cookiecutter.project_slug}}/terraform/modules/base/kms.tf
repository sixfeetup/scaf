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
