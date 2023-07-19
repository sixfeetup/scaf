resource "aws_cloudfront_origin_access_identity" "static_storage" {
  comment = "${module.global_variables.application}-${local.environment}"
}
