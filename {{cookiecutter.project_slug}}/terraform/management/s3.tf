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
