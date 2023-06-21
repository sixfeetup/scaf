resource "aws_s3_bucket" "cloudnative_pg" {
  bucket_prefix = "${module.global_variables.application}-cloudnative-pg-"
  tags          = local.common_tags
}

resource "aws_s3_bucket_versioning" "cnpg_versioning" {
  bucket = aws_s3_bucket.cloudnative_pg.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cnpg_encryption" {
  bucket = aws_s3_bucket.cloudnative_pg.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "cnpg_controls" {
  bucket = aws_s3_bucket.cloudnative_pg.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "cnpg_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.cnpg_controls]

  bucket = aws_s3_bucket.cloudnative_pg.id
  acl    = "private"
}