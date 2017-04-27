/**
 * IAM
 * -------------------------------------------------------------------------------------------------------------------
 */

/**
 * IAM Role to enable APIGateway logging to CloudWatch.
 */
resource "aws_iam_role" "platform_api_gateway_account" {
  name = "platform_api_gateway_account"
  assume_role_policy = "${file("${path.module}/IAM/CloudWatch/APIGateway/AssumeRolePolicy.json")}"
}

/**
 * IAM Role Policy to enable APIGateway logging to CloudWatch.
 */
resource "aws_iam_role_policy" "platform_api_gateway_account" {
  name = "platform_api_gateway_account"
  role = "${aws_iam_role.platform_api_gateway_account.id}"
  policy = "${file("${path.module}/IAM/CloudWatch/APIGateway/InlinePolicy.json")}"
}

/**
 * API Gateway
 * -------------------------------------------------------------------------------------------------------------------
 */

/**
 * Enable APIGateway logging to CloudWatch.
 */
resource "aws_api_gateway_account" "platform_api" {
  cloudwatch_role_arn = "${aws_iam_role.platform_api_gateway_account.arn}"
}

/**
 * REST API for the Platform.
 */
resource "aws_api_gateway_rest_api" "platform_api" {
  name = "platform_api_2"
  description = "Platform API 2"
}
