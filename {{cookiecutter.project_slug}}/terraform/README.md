# Terraform

This directory contains the Terraform configurations for the Scaf project. The
configurations are organized into several directories, each serving a specific
purpose. Below is a brief overview of each directory and instructions on how to
run the Terraform configurations.

## Directory Structure

- **bootstrap**: Bootstraps the Terraform state in an S3 bucket and a DynamoDB
  table. This configuration contains the states for all environments and only
  needs to be run once.

- **github**: Sets up a GitHub OIDC provider to allow GitHub to push container
  images to ECR repositories.

- **modules**: Contains a base module that is used by all environments.

- **prod**: Contains the configuration for the production environment.

- **sandbox**: Contains the configuration for the sandbox environment.

- **staging**: Contains the configuration for the staging environment.

## Setup Instructions

### Step 1: AWS Authentication

Ensure that you have installed AWS CLI version 2, as AWS SSO support is only
available in version 2 and above. Create a new AWS profile in `~/.aws/config`.
Here's an example of the `~/.aws/config` profile:
```
[profile scaf]
sso_start_url = https://sixfeetup.awsapps.com/start
sso_region = us-east-1
sso_account_id = <replace with your AWS account id>
sso_role_name = admin
region = us-east-1
output = json
```

Note the `sso_role_name` setting above. Make sure to use a role that provides
you with the necessary permissions to deploy infrastructure on your AWS account.

Export the `AWS_PROFILE` environment variable and continue logging in:
```
$ export AWS_PROFILE=scaf
$ aws sso login
```

This should open your browser, allowing you to sign in to your AWS account. Upon
successful login, you will see a message to confirm it:
```
Successfully logged into Start URL: https://sixfeetup.awsapps.com/start
```

### Step 2: Bootstrap

The first step is to bootstrap the Terraform state. This involves creating an S3
bucket and a DynamoDB table to manage the state and locking.

1. Navigate to the `bootstrap` directory:
    ```bash
    cd bootstrap
    ```

2. Initialize the Terraform configuration:
    ```bash
    terraform init
    ```

3. Plan the Terraform configuration:
    ```bash
    terraform plan -out="tfplan.out"
    ```

4. Apply the Terraform configuration:
    ```bash
    terraform apply tfplan.out
    ```

### Step 3: GitHub OIDC Provider

After bootstrapping the state, the next step is to set up the GitHub OIDC
provider.

1. Navigate to the `github` directory:
    ```bash
    cd ../github
    ```

2. Initialize the Terraform configuration:
    ```bash
    terraform init
    ```

3. Plan the Terraform configuration:
    ```bash
    terraform plan -out="tfplan.out"
    ```

4. Apply the Terraform configuration:
    ```bash
    terraform apply tfplan.out
    ```

### Step 4: Environment Configurations

The final step is to set up the respective environment configurations (prod,
sandbox, staging).

1. Navigate to the desired environment directory (e.g., `prod`, `sandbox`,
   `staging`):

    ```bash
    cd ../<environment>
    ```

2. Initialize the Terraform configuration:
    ```bash
    terraform init
    ```

3. Restrict the IPs allowed to manage the cluster. Edit
    `<environment>/cluster.tf` and set the following variables:
    ```
      kubectl_allowed_ips = "10.0.0.1/32,10.0.0.2/32"
      talos_allowed_ips = "10.0.0.1/32,10.0.0.2/32"
    ```

4. Plan the Terraform configuration:
    ```bash
    terraform plan -out="tfplan.out"
    ```

5. Apply the Terraform configuration:
    ```bash
    terraform apply tfplan.out
    ```

## Summary

The order of operations is critical for the correct setup of the Terraform
configurations:

1. Bootstrap the Terraform state (`bootstrap` directory).
2. Set up the GitHub OIDC provider (`github` directory).
3. Configure the desired environment (`prod`, `sandbox`, or `staging` directory).


Each step involves running `terraform init`, `terraform plan -out="tfplan.out"`,
and `terraform apply tfplan.out`.

Following these steps ensures that your infrastructure is set up correctly and
efficiently.
