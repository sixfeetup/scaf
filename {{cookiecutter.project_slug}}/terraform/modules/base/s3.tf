resource "aws_s3_bucket" "backups" {
  bucket = "${var.app_name}-${var.environment}-backups"
  tags   = local.common_tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backups" {
  bucket = aws_s3_bucket.backups.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket" "static_storage" {
  bucket = "${var.app_name}-${var.environment}-static-storage"
  tags   = local.common_tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "static_storage" {
  bucket = aws_s3_bucket.static_storage.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_cors_configuration" "static_storage" {
  bucket = aws_s3_bucket.static_storage.id

  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = [
      "GET",
      "PUT",
      "POST",
      "DELETE",
      "HEAD"
    ]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_bucket_versioning" "static_storage" {
  bucket = aws_s3_bucket.static_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "static_storage" {
  bucket = aws_s3_bucket.static_storage.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "static_storage" {
  depends_on = [aws_s3_bucket_ownership_controls.static_storage]

  bucket = aws_s3_bucket.static_storage.id
  acl    = "private"
}

resource "aws_s3_bucket_policy" "static_storage" {
  bucket = aws_s3_bucket.static_storage.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
        "Sid": "AllowCloudFrontServicePrincipalReadOnly",
        "Effect": "Allow",
        "Principal": {
            "Service": "cloudfront.amazonaws.com"
        },
        "Action": "s3:GetObject",
        "Resource": "${aws_s3_bucket.static_storage.arn}/*",
        "Condition": {
            "StringEquals": {
                "AWS:SourceArn": "${aws_cloudfront_distribution.cloudfront.arn}"
            }
        }
    }
}
EOF
}
