output "PlatformRestApiId" {
  value = "${aws_api_gateway_rest_api.PlatformAPI.id}"
}
output "PlatformRestApiRootResourceId" {
  value = "${aws_api_gateway_rest_api.PlatformAPI.root_resource_id}"
}
output "PlatformRestApiDeploymentId" {
  value = "${aws_api_gateway_deployment.PlatformAPI.id}"
}
