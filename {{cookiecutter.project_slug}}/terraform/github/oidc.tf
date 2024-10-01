terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.51.1"
    }
  }
  backend "s3" {
    region         = "{{ cookiecutter.aws_region }}"
    bucket         = "{{ cookiecutter.project_dash }}-terraform-state"
    key            = "{{ cookiecutter.project_dash }}.github.json"
    encrypt        = true
    dynamodb_table = "{{ cookiecutter.project_dash }}-terraform-state"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  # https://stackoverflow.com/questions/69247498/how-can-i-calculate-the-thumbprint-of-an-openid-connect-server
  # Thumbprints for GitHub
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
}

# Define the IAM role
resource "aws_iam_role" "github_oidc_role" {
  name = "{{ cookiecutter.project_slug }}-github-oidc-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${aws_iam_openid_connect_provider.github.arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:{{ cookiecutter.source_control_organization_slug }}/{{ cookiecutter.repo_name }}:*"
        },
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        }
        }
      }
    }
  ]
}
EOF
}
