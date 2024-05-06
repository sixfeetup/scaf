resource "aws_cloudfront_origin_access_identity" "cluster_origin_access_identity" {
  comment = "${var.application}-${var.environment}"
}

resource "aws_cloudfront_origin_access_control" "static_storage" {
  name                              = "static_storage"
  description                       = "Backend Bucket Access Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "ec2_cluster" {
  enabled             = true
  aliases             = [var.domain]
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
    domain_name = var.cluster_domain
    origin_id   = var.cluster_id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols   = ["TLSv1.1", "TLSv1.2"]
    }
  }

  default_cache_behavior {
    # Using the CachingOptimized policy:
    cache_policy_id = data.aws_cloudfront_cache_policy.caching_optimized.id
    # Using the AllViewerExceptHostHeader origin policy
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer_except_host.id

    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    target_origin_id       = var.cluster_id
  }

  ordered_cache_behavior {
    path_pattern           = "/static/*"
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.static_storage.id
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
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
  name = "${var.environment}-cloudfront-invalidator"
}

resource "aws_iam_user_policy" "cloudfront_invalidator" {
  name   = "${var.environment}-cloudfront-invalidator"
  user   = aws_iam_user.cloudfront_invalidator.name
  policy = data.aws_iam_policy_document.cloudfront_invalidator.json
}

data "aws_iam_policy_document" "cloudfront_invalidator" {
  statement {
    sid       = "CloudfrontInvalidation"
    actions   = ["cloudfront:CreateInvalidation"]
    effect    = "Allow"
    resources = [var.cluster_arn]
  }
}

resource "aws_iam_access_key" "cloudfront_invalidator" {
  user = aws_iam_user.cloudfront_invalidator.name
}
