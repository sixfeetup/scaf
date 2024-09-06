# :package: How to deploy

## Infrastructure provisioning

Terraform can be used to provision AWS resources for your project deployment.
terraform/ec2-cluster will create an EC2 instance running a kubernetes cluster for your project.
Check [terraform/README.md](/terraform/README.md) for more information and steps for provisioning resources.

## Project deployment

ArgoCD and kubernetes can be used to automate the deployment of your project to your infrastructure.
ArgoCD will watch for changes in your repository and apply the kubernetes manifests.
Check [k8s/argocd/README.md](/k8s/argocd/README.md) for more information on creating and setting up the ArgoCD application.
