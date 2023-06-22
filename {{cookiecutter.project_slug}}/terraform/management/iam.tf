resource "aws_iam_user" "cicd_user" {
  name = "cicd_user"
}

resource "aws_iam_access_key" "cicd_user" {
  user = aws_iam_user.cicd_user.name
}

resource "aws_iam_user_policy" "cicd_user" {
  name = "cicd_user_policy"
  user = aws_iam_user.cicd_user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:GetAuthorizationToken"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:CompleteLayerUpload",
        "ecr:DescribeImages",
        "ecr:GetDownloadUrlForLayer",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart"
      ],
      "Effect": "Allow",
      "Resource": [
        "${module.ecr_backend.repository_arn}"
      ]
    },
    {
      "Action": [
          "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.cloudnative_pg.arn}/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": "arn:aws:ec2:{{cookiecutter.aws_region}}:{{cookiecutter.aws_account_id}}:instance/*"
    }
  ]
}
EOF
}
