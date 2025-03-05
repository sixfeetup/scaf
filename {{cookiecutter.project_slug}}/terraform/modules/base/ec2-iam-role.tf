# Create IAM policy for S3 access
resource "aws_iam_policy" "s3_rw_policy" {
  name = "${var.app_name}-${var.environment}-S3ReadWritePolicy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObjectAcl",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject",
          "s3:PutObjectAcl"
        ]
        Resource = [
          "${aws_s3_bucket.backups.arn}",
          "${aws_s3_bucket.backups.arn}/*",
          "${aws_s3_bucket.static_storage.arn}",
          "${aws_s3_bucket.static_storage.arn}/*"
        ]
      }
    ]
  })
}

# Create AssumeRole IAM role for EC2 instances
resource "aws_iam_role" "ec2_role" {
  name = "${var.app_name}-${var.environment}-EC2S3ReadWriteRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the S3 policy to the role
resource "aws_iam_role_policy_attachment" "attach_s3_rw_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_rw_policy.arn
}

# Create an instance profile for the role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.app_name}-${var.environment}-EC2InstanceProfile"
  role = aws_iam_role.ec2_role.name
}

# Create ECR read policy for EC2 instances
resource "aws_iam_policy" "ecr_read_policy" {
  name        = "${var.app_name}-${var.environment}-ECRReadPolicy"
  description = "Policy to allow read access to an ECR repository"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:DescribeImageScanFindings"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach the ECR policy to the ec2 role
resource "aws_iam_role_policy_attachment" "ecr_read_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ecr_read_policy.arn
}
{% if cookiecutter.mail_service == "Amazon SES" %}

# Create Amazon SES policy for EC2 instances
resource "aws_iam_policy" "amazon_ses_policy" {
  name        = "${var.app_name}-${var.environment}-AmazonSES"
  description = "Allow sending email using Amazon SES"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail",
          "ses:GetSendQuota",
          "ses:GetSendStatistics"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach the Amazon SES policy to the ec2 role
resource "aws_iam_role_policy_attachment" "amazon_ses_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.amazon_ses_policy.arn
}
{% endif %}
