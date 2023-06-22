resource "aws_route53_zone" "route_zone" {
  name = module.global_variables.domain_name
  tags = local.common_tags
}
