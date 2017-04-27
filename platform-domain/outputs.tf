output "delegation_set_id" {
  value = "${aws_route53_delegation_set.platform.id}"
}
output "hosted_zone_id" {
  value = "${aws_route53_zone.platform.id}"
}
