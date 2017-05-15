output "deployment_invoke_url" {
  value = "${aws_api_gateway_deployment.platform_api.invoke_url}"
}
