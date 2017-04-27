/**
 * IAM
 * -------------------------------------------------------------------------------------------------------------------
 */

/**
 * IAM Role to enable APIGateway logging to CloudWatch.
 */
resource "aws_iam_role" "PlatformAPIGatewayAccount" {
  name = "platform_api_gateway_account"
  assume_role_policy = "${file("${path.module}/IAM/CloudWatch/APIGateway/AssumeRolePolicy.json")}"
}

/**
 * IAM Role Policy to enable APIGateway logging to CloudWatch.
 */
resource "aws_iam_role_policy" "PlatformAPIGatewayAccount" {
  name = "platform_api_gateway_account"
  role = "${aws_iam_role.PlatformAPIGatewayAccount.id}"
  policy = "${file("${path.module}/IAM/CloudWatch/APIGateway/InlinePolicy.json")}"
}

/**
 * API Gateway
 * -------------------------------------------------------------------------------------------------------------------
 */

/**
 * Enable APIGateway logging to CloudWatch.
 */
resource "aws_api_gateway_account" "Platform" {
  cloudwatch_role_arn = "${aws_iam_role.PlatformAPIGatewayAccount.arn}"
}

/**
 * REST API for the Platform.
 */
resource "aws_api_gateway_rest_api" "PlatformAPI" {
  name = "platform_api"
  description = "Platform API"
}

/**
 * REST API Deployment for the Platform.
 */
resource "aws_api_gateway_deployment" "PlatformAPI" {
  rest_api_id = "${aws_api_gateway_rest_api.PlatformAPI.id}"
  stage_name = "prod"
}
