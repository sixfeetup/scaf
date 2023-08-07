# k3s on AWS ec2

Deploy an AWS ec2 instance with a k3s cluster installed (this only needs to be set up once).

## Prerequisites

aws cli and terraform

## Login to AWS

Create a SFU profile for your AWS environment and add it to `~/.aws/config` eg:

```
[profile {{cookiecutter.project_slug}}]
region = {{cookiecutter.aws_region}}
output = json
```

Switch to your profile and log in:

```
export AWS_PROFILE={{cookiecutter.project_slug}}
aws sso login
```

## Terraform init

```
terraform init
```

## Generate terraform.tfvars

```
make generate-tfvars
```

## Create an SSH key (or use your own)

```
make key-pair
```

## Deploy microk8s instance on AWS

```
make deploy
```

## Add k3s cluster config

Once your ec2 instance is up and running, you can run 
```
make config
``` 
to add the cluster to your local kubernetes configuration. Add the new cluster to your `KUBECONFIG` environment variable:

```
export KUBECONFIG=~/.kube/{{cookiecutter.project_slug}}.ec2.config
```

Update KUBECONFIG in your `.bashrc` file to ensure it is set automatically in future:

```
export KUBECONFIG=~/.kube/config:~/.kube/{{cookiecutter.project_slug}}.ec2.config
```

Check that the new cluster is listed:

```
kubectl config get-contexts
```

Switch to the `{{cookiecutter.project_slug}}-ec2-cluster`:

```
kubectl config use-context {{cookiecutter.project_slug}}-ec2-cluster
```

## Credentials

The frontend and backend ECR repo's are defined in hosting-terraform.

In order for skaffold to push images and kubernetes to pull images, we need
to authenticate against the ECR repository.

Switch to the AWS profile and log in:

```
export AWS_PROFILE={{cookiecutter.project_slug}}
aws sso login
```

You need to pipe a log in password to docker to allow skaffold to push images to ECR:

```
aws ecr get-login-password --region {{cookiecutter.aws_region}} | docker login --username AWS --password-stdin {{cookiecutter.aws_account_id}}.dkr.ecr.{{cookiecutter.aws_region}}.amazonaws.com
```

Finally, you need to add credentials to the kubernetes cluster so that it can pull images from the ECR repository.

```
kubectl create secret docker-registry regcred \
  --docker-server={{cookiecutter.aws_account_id}}.dkr.ecr.{{cookiecutter.aws_region}}.amazonaws.com \
  --docker-username=AWS \
  --docker-password=$(aws ecr get-login-password) \
  --namespace {{cookiecutter.project_dash}}-sandbox
```

NB: AWS credentials will expire after 4 hours. If you are unable to push or pull images to ECR, you will need to reauthenticate.

To simplify this, you can run `AWS_PROFILE={{cookiecutter.project_slug}} make kubecreds`
