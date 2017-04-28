/**
 * Lambda
 * -------------------------------------------------------------------------------------------------------------------
 */

/**
 * Create the Lambda Function.
 */
resource "aws_lambda_function" "aws_serverless_express" {
  filename = "${var.filename}"
  function_name = "${var.function_name}"
  role = "${var.role_arn}"
  handler = "${var.handler}"
  runtime = "${var.runtime}"
  source_code_hash = "${base64sha256(file("${var.filename}"))}"
}

/**
 * Allow APIGateway to access the GraphQL Lambda Function.
 */
resource "aws_lambda_permission" "aws_serverless_express" {
  depends_on = [
    "aws_lambda_function.aws_serverless_express"
  ]
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = "${var.function_name}"
  principal = "apigateway.amazonaws.com"
}

/**
 * API Gateway
 * -------------------------------------------------------------------------------------------------------------------
 */

/**
 * Create a Proxy Resource for the Lambda Function.
 */
resource "aws_api_gateway_resource" "aws_serverless_express" {
  rest_api_id = "${var.rest_api_id}"
  parent_id = "${var.rest_api_parent_resource_id}"
  path_part = "{proxy+}"
}

/**
 * Create the ANY method on the Proxy Resource.
 */
resource "aws_api_gateway_method" "aws_serverless_express" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.aws_serverless_express.id}"
  http_method = "ANY"
  authorization = "NONE"
}

/**
 * Create the AWS_PROXY Integration for the ANY method.
 */
resource "aws_api_gateway_integration" "aws_serverless_express" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.aws_serverless_express.id}"
  http_method = "${aws_api_gateway_method.aws_serverless_express.http_method}"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.aws_serverless_express.arn}/invocations"
  integration_http_method = "POST"
}

/**
 * Create the Integration Response for status 200.
 */
resource "aws_api_gateway_integration_response" "aws_serverless_express" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.aws_serverless_express.id}"
  http_method = "${aws_api_gateway_method.aws_serverless_express.http_method}"
  status_code = "${aws_api_gateway_method_response.aws_serverless_express.status_code}"
  depends_on = ["aws_api_gateway_integration.aws_serverless_express"]
}

/**
 * Create the ANY Method Response for status 200.
 */
resource "aws_api_gateway_method_response" "aws_serverless_express" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.aws_serverless_express.id}"
  http_method = "${aws_api_gateway_method.aws_serverless_express.http_method}"
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

/**
 * Create an indicator resource signaling the readyness to deploy the REST API.
 */
resource "null_resource" "aws_serverless_express" {
  depends_on = [
    "aws_api_gateway_integration.aws_serverless_express",
    "aws_api_gateway_integration_response.aws_serverless_express"
  ]
}
