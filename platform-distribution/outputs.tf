output "distribution_domain_name" {
  value = "${aws_cloudfront_distribution.PlatformDistribution.domain_name}"
}
output "rest_api_root_resource_id" {
  value = "${aws_cloudfront_distribution.PlatformDistribution.hosted_zone_id}"
}
