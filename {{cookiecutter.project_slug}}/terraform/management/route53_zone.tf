resource "aws_route53_zone" "route_zone" {
  name = "{{cookiecutter.domain_name}}"
  tags = local.common_tags
}