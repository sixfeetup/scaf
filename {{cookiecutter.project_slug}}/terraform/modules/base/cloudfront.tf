data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_cache_policy" "caching_disabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "all_viewer_except_host" {
  name = "Managed-AllViewerExceptHostHeader"
}

resource "aws_cloudfront_origin_access_identity" "s3_access_identity" {
  comment = "${var.app_name}-${var.environment}"
}

resource "aws_cloudfront_origin_access_control" "static_storage" {
  name                              = "${var.app_name}-${var.environment}-static-storage"
  description                       = "Backend Bucket Access Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "cloudfront" {
  enabled             = true
  aliases             = [var.domain_name]
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"
  default_root_object = ""

  // Django static storage s3 bucket
  origin {
    domain_name              = aws_s3_bucket.static_storage.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.static_storage.id
    origin_access_control_id = aws_cloudfront_origin_access_control.static_storage.id
  }


  // Kubernetes cluster
  origin {
    domain_name = var.nextjs_domain_name
    origin_id   = var.cluster_name

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols   = ["TLSv1.1", "TLSv1.2"]
    }
  }

  // Cache behavior for /api paths
  ordered_cache_behavior {
    path_pattern             = "/api/*"
    target_origin_id         = var.cluster_name
    allowed_methods          = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods           = ["GET", "HEAD"]
    viewer_protocol_policy   = "redirect-to-https"
    cache_policy_id          = data.aws_cloudfront_cache_policy.caching_disabled.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer_except_host.id
  }

  default_cache_behavior {
    cache_policy_id          = data.aws_cloudfront_cache_policy.caching_disabled.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer_except_host.id
    allowed_methods          = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods           = ["GET", "HEAD"]
    viewer_protocol_policy   = "redirect-to-https"
    target_origin_id         = var.cluster_name
  }

  viewer_certificate {
    ssl_support_method       = "sni-only"
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    minimum_protocol_version = "TLSv1.2_2018"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = local.common_tags
}

resource "aws_iam_user" "cloudfront_invalidator" {
  name = "${var.app_name}-${var.environment}-cloudfront-invalidator"
}

resource "aws_iam_user_policy" "cloudfront_invalidator" {
  name   = "${var.app_name}-${var.environment}-cloudfront-invalidator"
  user   = aws_iam_user.cloudfront_invalidator.name
  policy = data.aws_iam_policy_document.cloudfront_invalidator.json
}

data "aws_iam_policy_document" "cloudfront_invalidator" {
  statement {
    sid       = "CloudfrontInvalidation"
    actions   = ["cloudfront:CreateInvalidation"]
    effect    = "Allow"
    resources = [aws_cloudfront_distribution.cloudfront.arn]
  }
}

resource "aws_iam_access_key" "cloudfront_invalidator" {
  user = aws_iam_user.cloudfront_invalidator.name
}

