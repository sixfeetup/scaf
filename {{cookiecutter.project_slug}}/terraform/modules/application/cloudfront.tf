resource "aws_cloudfront_origin_access_identity" "static_storage" {
  comment = "${var.application}-${var.environment}"
}
