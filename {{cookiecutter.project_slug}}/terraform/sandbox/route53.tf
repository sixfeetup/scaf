
data "aws_route53_zone" "route_zone" {
  name = "{{cookiecutter.domain_name}}"
}

# record for calls to frontend
resource "aws_route53_record" "sandbox" {
  zone_id = aws_route53_zone.route_zone.zone_id
  name    = var.domain
  type    = "A"
  records = [data.aws_instance.ec2_cluster.public_ip]
  ttl     = 600
}

# record for api calls to backend
resource "aws_route53_record" "sandbox_api" {
  zone_id = aws_route53_zone.route_zone.zone_id
  name    = var.api_domain
  type    = "A"
  records = [data.aws_instance.ec2_cluster.public_ip]
  ttl     = 600
}
