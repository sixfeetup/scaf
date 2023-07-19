resource "aws_iam_policy" "{{cookiecutter.project_slug}}_user_policy" {
  name   = "task-${module.global_variables.application}-${var.environment}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:GetCallerIdentity"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "cloudfront:CreateInvalidation",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObjectAcl",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:DeleteObject",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "${aws_s3_bucket.static_storage.arn}/*",
                "${aws_s3_bucket.static_storage.arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
              "SES:SendEmail",
              "SES:SendRawEmail"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_user" "{{cookiecutter.project_slug}}_user" {
  name = "${module.global_variables.application}-user-${var.environment}"
}

resource "aws_iam_access_key" "{{cookiecutter.project_slug}}_user_key" {
  user = aws_iam_user.{{cookiecutter.project_slug}}_user.name
}

resource "aws_iam_user_policy_attachment" "{{cookiecutter.project_slug}}_user_policy_attachment" {
  user       = aws_iam_user.{{cookiecutter.project_slug}}_user.name
  policy_arn = aws_iam_policy.{{cookiecutter.project_slug}}_user_policy.arn
}