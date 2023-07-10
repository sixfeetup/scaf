### Terraform is an infrastructure as code tool that manages provisioning AWS resources.
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli 

The terraform directory handles all infrastructure provisioning using terraform.

### Commands:
* `terraform init`: needs to be run first for every directory, installs the terraform providers
* `terraform plan`: shows changes that will be done by the manifests, no changes will be applied yet
* `terraform apply`: applies the changes shown by the plan output

### First step:
* `./bootstrap`  
Run apply in the bootstrap directory first to set up the terraform remote state used in all other manifests.
* If your account is not an organisation account you will need to remove or adjust the assume_role block in the bootstrap/init.tf file.

### Next steps:
* `./management`  
Set up the ECR repositories for the docker images, as well as IAM users and route 53 zone, this should be run after bootstrap.

* `./ec2_cluster`  
Sets up an EC2 instance and deploys a k3s cluster on it. For more information follow ./ec2_cluster/README.md  
Note this will create a t2.medium instance that does not fall under the free tier.  
This should be set up before attempting to deploy prod/sandbox.

* `./prod` and `./sandbox`  
Sets up route53 for prod and sandbox respectively.

### After terraform has initialised the deployment process will need to be updated with its outputs:
* update CI/CD with the AWS access keys of the IAM `cicd_user`.
* update kubernetes manifests and any CI/CD making calls to the ECR images with the ECR url.
* update CloudNativePG manifest to set the backup with S3 `cloudnative_pg` bucket url.
