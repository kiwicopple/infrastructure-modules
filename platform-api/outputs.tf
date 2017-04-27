output "rest_api_id" {
  value = "${aws_api_gateway_rest_api.platform_api.id}"
}
output "rest_api_root_resource_id" {
  value = "${aws_api_gateway_rest_api.platform_api.root_resource_id}"
}
