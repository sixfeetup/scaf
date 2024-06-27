provider "helm" {
  kubernetes {
    config_path = "${path.module}/kubeconfig"
  }
}

provider "kubernetes" {
  config_path = "${path.module}/kubeconfig"
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
    labels = {
      "release"                            = "kube-prometheus-stack"
      "pod-security.kubernetes.io/audit"   = "privileged"
      "pod-security.kubernetes.io/enforce" = "privileged"
      "pod-security.kubernetes.io/warn"    = "privileged"
    }
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "6.9.2"
  create_namespace = true

  # SSL termination done by Traefik
  set {
    name  = "configs.params.server.insecure"
    value = "true"
  }

  depends_on = [resource.null_resource.kubeconfig_file]
}

locals {
  repo_name                = var.repo_name
  repo_url                 = var.repo_url
  argocd_github_deploy_key = file("./argocd_github_deploy_key")
  type_b64                 = base64encode("git")
  repo_url_b64             = base64encode(local.repo_url)
  github_deploy_key_b64    = base64encode(local.argocd_github_deploy_key)
}

data "template_file" "repo_creds" {
  template = file("${path.module}/repocreds.template.yaml")

  vars = {
    repo_name             = local.repo_name
    type_b64              = local.type_b64
    repo_url_b64          = local.repo_url_b64
    github_deploy_key_b64 = local.github_deploy_key_b64
  }
}

resource "local_file" "repo_creds" {
  content  = data.template_file.repo_creds.rendered
  filename = "${path.module}/repocreds.yaml"
}

resource "kubectl_manifest" "apply_secret" {
  yaml_body  = data.template_file.repo_creds.rendered
  depends_on = [local_file.repo_creds, helm_release.argocd]
}

resource "kubectl_manifest" "argocd_root_app" {
  yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: root
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
  labels:
    app.kubernetes.io/name: root
spec:
  destination:
    namespace: argocd
    server: https://kubernetes.default.svc
  project: default
  source:
    path: argocd/prod/apps
    repoURL: {{ cookiecutter.repo_url }}
    targetRevision: HEAD
  syncPolicy:
    automated:
      allowEmpty: true
      prune: true
      selfHeal: true
    syncOptions:
    - allowEmpty=true
YAML
}
