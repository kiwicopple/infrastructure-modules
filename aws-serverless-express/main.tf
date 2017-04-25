/**
 * Lambda
 * -------------------------------------------------------------------------------------------------------------------
 */

/**
 * Create the Lambda Function.
 */
resource "aws_lambda_function" "AwsServerlessExpress" {
  filename = "${var.filename}"
  function_name = "platform_graphql_endpoint"
  role = "${var.role_arn}"
  handler = "index.handler"
  runtime = "nodejs4.3"
  source_code_hash = "${base64sha256(file("${var.filename}"))}"
}

/**
 * Allow APIGateway to access the GraphQL Lambda Function.
 */
resource "aws_lambda_permission" "AwsServerlessExpress" {
  depends_on = [
    "aws_lambda_function.AwsServerlessExpress"
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
resource "aws_api_gateway_resource" "AwsServerlessExpress" {
  rest_api_id = "${var.rest_api_id}"
  parent_id = "${var.rest_api_parent_resource_id}"
  path_part = "{proxy+}"
}

/**
 * Create the ANY method on the Proxy Resource.
 */
resource "aws_api_gateway_method" "AwsServerlessExpress" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.AwsServerlessExpress.id}"
  http_method = "ANY"
  authorization = "NONE"
}

/**
 * Create the AWS_PROXY Integration for the ANY method.
 */
resource "aws_api_gateway_integration" "AwsServerlessExpress" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.AwsServerlessExpress.id}"
  http_method = "${aws_api_gateway_method.AwsServerlessExpress.http_method}"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.AwsServerlessExpress.arn}/invocations"
  integration_http_method = "POST"
}

/**
 * Create the Integration Response for status 200.
 */
resource "aws_api_gateway_integration_response" "AwsServerlessExpress" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.AwsServerlessExpress.id}"
  http_method = "${aws_api_gateway_method.AwsServerlessExpress.http_method}"
  status_code = "${aws_api_gateway_method_response.AwsServerlessExpress.status_code}"
}

/**
 * Create the ANY Method Response for status 200.
 */
resource "aws_api_gateway_method_response" "AwsServerlessExpress" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.AwsServerlessExpress.id}"
  http_method = "${aws_api_gateway_method.AwsServerlessExpress.http_method}"
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}
