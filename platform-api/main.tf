/**
 * API Gateway
 * -------------------------------------------------------------------------------------------------------------------
 */

/**
 * REST API for the Platform.
 */
resource "aws_api_gateway_rest_api" "platform_api" {
  name = "platform_api_2"
  description = "Platform API 2"
}

/**
 * REST API Deployment for the Platform.
 */
resource "aws_api_gateway_deployment" "platform_api" {
  rest_api_id = "${aws_api_gateway_rest_api.platform_api.id}"
  stage_name = "prod"
  depends_on = ["null_resource.ready_for_deployment"]
}

/**
 * Dummy resource to capture external dependencies.
 */
resource "null_resource" "ready_for_deployment" {
  triggers {
    dummy = "${length(var.ready_for_deployment)}"
  }
}
