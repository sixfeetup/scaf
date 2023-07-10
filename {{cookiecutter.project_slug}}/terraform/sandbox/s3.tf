resource "aws_s3_bucket" "static_storage" {
  bucket_prefix = "${module.global_variables.application}-${var.environment}-"

  acl = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
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

  versioning {
    enabled = true
  }

  tags = local.common_tags
}

resource "aws_s3_bucket_policy" "static_storage" {
  bucket = aws_s3_bucket.static_storage.id
  policy = <<EOF
{
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Principal": {
                "AWS": "${aws_cloudfront_origin_access_identity.static_storage.iam_arn}"
            },
            "Resource": "${aws_s3_bucket.static_storage.arn}/*"
        }
    ]
}
EOF
}
