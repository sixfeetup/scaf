resource "aws_s3_bucket" "static_storage" {
  for_each = toset(var.environments)
  bucket_prefix = "${module.global_variables.application}-${each.value}-"

  tags = merge(
    local.common_tags,
    {
      environment        = each.value
      "automation.config" = join(".", [module.global_variables.application, each.value])
    }
  )
}

resource "aws_s3_bucket_server_side_encryption_configuration" "static_storage" {
  for_each = aws_s3_bucket.static_storage
  bucket = aws_s3_bucket.static_storage.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_cors_configuration" "static_storage" {
  for_each = aws_s3_bucket.static_storage
  bucket = each.value.bucket.id # todo: confirm this is right

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
  for_each = aws_s3_bucket.static_storage
  bucket = each.value.bucket.id # todo: confirm this is right

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "static_storage" {
  for_each = aws_s3_bucket.static_storage
  bucket = each.value.bucket.id # todo: confirm this is right

  rule {
    object_ownership = "ObjectWriter"
  }
}

# todo: can we eliminate this completely now?
resource "aws_s3_bucket_acl" "static_storage" {
  for_each = aws_s3_bucket.static_storage
  bucket = each.value.bucket.id # todo: confirm this is right

  # todo: if not eliminate, do we need to add reference to match different env's controls?
  depends_on = [aws_s3_bucket_ownership_controls.static_storage]

  acl    = "private"
}
