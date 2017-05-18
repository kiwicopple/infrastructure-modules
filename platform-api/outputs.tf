output "deployment_id" {
  value = "${aws_api_gateway_deployment.platform_api.id}"
}
output "deployment_invoke_url" {
  value = "${aws_api_gateway_deployment.platform_api.invoke_url}"
}
output "deployment_execution_arn" {
  value = "${aws_api_gateway_deployment.platform_api.execution_arn}"
}
output "rest_api_id" {
  value = "${aws_api_gateway_rest_api.platform_api.id}"
}
output "rest_api_root_resource_id" {
  value = "${aws_api_gateway_rest_api.platform_api.root_resource_id}"
}
output "cloudfront_distribution_domain_name" {
  value = "${aws_cloudfront_distribution.platform_distribution.domain_name}"
}
output "cloudfront_distribution_hosted_zone_id" {
  value = "${aws_cloudfront_distribution.platform_distribution.hosted_zone_id}"
}
