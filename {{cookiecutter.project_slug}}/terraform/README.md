The terraform directory handles all infrastructure provisioning using terraform

./management
    Set up the terraform remote state, IAM users and route 53 zone, these should be run first.

./ec2_cluster
    Sets up an EC2 instance and deploys a k3s cluster on it. For more information ./ec2_cluster/README.md
    Note this will create a t2.medium instance that does not fall under the free tier.
    This should be run before attempting to deploy prod/sandbox.

./prod and ./sandbox
    Sets up route53 for prod and sandbox respectively.
