
data "aws_route53_zone" "route_zone" {
  name = var.domain_zone
}

# record for api calls to backend
resource "aws_route53_record" "application-api" {
  zone_id = data.aws_route53_zone.route_zone.zone_id
  name    = var.api_domain
  type    = "A"
  records = [var.cluster_public_id]
  ttl     = 600
}

// record for cluster ip
resource "aws_route53_record" "application-k8s" {
  zone_id = data.aws_route53_zone.route_zone.zone_id
  name    = var.cluster_domain
  ttl     = 3600
  type    = "A"
  records = [var.cluster_public_id]
}

# record for argocd call
resource "aws_route53_record" "application-argocd" {
  zone_id = data.aws_route53_zone.route_zone.zone_id
  name    = var.argocd_domain
  type    = "A"
  records = [var.cluster_public_id]
  ttl     = 600
}

# record for frontend call
resource "aws_route53_record" "application" {
  zone_id = data.aws_route53_zone.route_zone.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.ec2_cluster.domain_name
    zone_id                = aws_cloudfront_distribution.ec2_cluster.hosted_zone_id
    evaluate_target_health = false
  }
}
