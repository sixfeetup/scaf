
data "aws_route53_zone" "route_zone" {
  name = var.domain_zone
}

# record for calls to cluster
resource "aws_route53_record" "routes" {
  for_each = var.domain_urls
  zone_id  = data.aws_route53_zone.route_zone.zone_id
  name     = each.value
  type     = "A"
  records  = [var.cluster_public_id]
  ttl      = 600
}
