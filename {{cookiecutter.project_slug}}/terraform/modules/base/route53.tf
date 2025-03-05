resource "aws_route53_zone" "route_zone" {
  name = var.domain_name
  tags = local.common_tags
}

resource "aws_route53_record" "api" {
  zone_id = aws_route53_zone.route_zone.zone_id
  name    = var.api_domain_name
  type    = "CNAME"
  records = [module.elb_k8s_elb.elb_dns_name]
  ttl     = 600
}

resource "aws_route53_record" "k8s" {
  zone_id = aws_route53_zone.route_zone.zone_id
  name    = var.cluster_domain_name
  type    = "CNAME"
  records = [module.elb_k8s_elb.elb_dns_name]
  ttl     = 600
}

resource "aws_route53_record" "nextjs" {
  zone_id = aws_route53_zone.route_zone.zone_id
  name    = var.nextjs_domain_name
  type    = "CNAME"
  records = [module.elb_k8s_elb.elb_dns_name]
  ttl     = 600
}

resource "aws_route53_record" "frontend" {
  zone_id = aws_route53_zone.route_zone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cloudfront.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "frontend-v6" {
  zone_id = aws_route53_zone.route_zone.zone_id
  name    = var.domain_name
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.cloudfront.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront.hosted_zone_id
    evaluate_target_health = false
  }
}

# record for argocd call
resource "aws_route53_record" "argocd" {
  zone_id = aws_route53_zone.route_zone.zone_id
  name    = var.argocd_domain_name
  type    = "CNAME"
  records = [module.elb_k8s_elb.elb_dns_name]
  ttl     = 600
}

# record for prometheus call
resource "aws_route53_record" "prometheus" {
  zone_id = aws_route53_zone.route_zone.zone_id
  name    = var.prometheus_domain_name
  type    = "CNAME"
  records = [module.elb_k8s_elb.elb_dns_name]
  ttl     = 600
}
