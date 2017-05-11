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
  binary_media_types = ["text/html", "application/json"]
}

/**
 * REST API Deployment for the Platform.
 */
resource "aws_api_gateway_deployment" "platform_api" {
  rest_api_id = "${aws_api_gateway_rest_api.platform_api.id}"
  stage_name = "${var.stage_name}"
  stage_description = "${var.stage_description}"
}
