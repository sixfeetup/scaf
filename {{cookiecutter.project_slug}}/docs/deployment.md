# :package: How to deploy

## Infrastructure provisioning

Terraform can be used to provision AWS resources for your project deployment.
Read [terraform/README.md](/terraform/README.md) for more information and steps for provisioning resources.

## Application deployment

Use ArgoCD and Kubernetes to automate the deployment of your application to your infrastructure. ArgoCD monitors changes within your repository, promptly applying the relevant Kubernetes manifests. Read [bootstrap-cluster/README.md](/bootstrap-cluster/README.md) for more details.
