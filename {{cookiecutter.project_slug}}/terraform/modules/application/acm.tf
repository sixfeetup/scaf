resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert" {
  name     = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  type     = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
  zone_id  = data.aws_route53_zone.route_zone.id
  records  = [tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value]
  ttl      = 300
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = aws_route53_record.cert.*.fqdn
}