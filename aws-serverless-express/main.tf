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
 * API Gateway Root Resource
 * -------------------------------------------------------------------------------------------------------------------
 */

/**
 * Create a Proxy Resource for the Lambda Function.
 */
resource "aws_api_gateway_resource" "aws_serverless_express_root" {
  count = "${var.create_child_resource}"
  rest_api_id = "${var.rest_api_id}"
  parent_id = "${var.rest_api_parent_resource_id}"
  path_part = "${var.child_resource_path}"
}

/**
 * Create the ANY method on the Proxy Resource.
 */
resource "aws_api_gateway_method" "aws_serverless_express_root" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${element(concat(aws_api_gateway_resource.aws_serverless_express_root.*.id, list(var.rest_api_parent_resource_id)), 0)}"
  http_method = "ANY"
  authorization = "NONE"
}

/**
 * Create the AWS_PROXY Integration for the ANY method.
 */
resource "aws_api_gateway_integration" "aws_serverless_express_root" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${element(concat(aws_api_gateway_resource.aws_serverless_express_root.*.id, list(var.rest_api_parent_resource_id)), 0)}"
  http_method = "${aws_api_gateway_method.aws_serverless_express_root.http_method}"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.aws_serverless_express.arn}/invocations"
  integration_http_method = "POST"
}

/**
 * Create the Integration Response for status 200.
 */
resource "aws_api_gateway_integration_response" "aws_serverless_express_root" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${element(concat(aws_api_gateway_resource.aws_serverless_express_root.*.id, list(var.rest_api_parent_resource_id)), 0)}"
  http_method = "${aws_api_gateway_method.aws_serverless_express_root.http_method}"
  status_code = "${aws_api_gateway_method_response.aws_serverless_express_root.status_code}"
  depends_on = ["aws_api_gateway_integration.aws_serverless_express_root"]
}

/**
 * Create the ANY Method Response for status 200.
 */
resource "aws_api_gateway_method_response" "aws_serverless_express_root" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${element(concat(aws_api_gateway_resource.aws_serverless_express_root.*.id, list(var.rest_api_parent_resource_id)), 0)}"
  http_method = "${aws_api_gateway_method.aws_serverless_express_root.http_method}"
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

/**
 * API Gateway Greedy Child Resource
 * -------------------------------------------------------------------------------------------------------------------
 */

/**
 * Create a Proxy Resource for the Lambda Function.
 */
resource "aws_api_gateway_resource" "aws_serverless_express_proxy" {
  rest_api_id = "${var.rest_api_id}"
  parent_id = "${element(concat(aws_api_gateway_resource.aws_serverless_express_root.*.id, list(var.rest_api_parent_resource_id)), 0)}"
  path_part = "{proxy+}"
}

/**
 * Create the ANY method on the Proxy Resource.
 */
resource "aws_api_gateway_method" "aws_serverless_express_proxy" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.aws_serverless_express_proxy.id}"
  http_method = "ANY"
  authorization = "NONE"
}

/**
 * Create the AWS_PROXY Integration for the ANY method.
 */
resource "aws_api_gateway_integration" "aws_serverless_express_proxy" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.aws_serverless_express_proxy.id}"
  http_method = "${aws_api_gateway_method.aws_serverless_express_proxy.http_method}"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.aws_serverless_express.arn}/invocations"
  integration_http_method = "POST"
}

/**
 * Create the Integration Response for status 200.
 */
resource "aws_api_gateway_integration_response" "aws_serverless_express_proxy" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.aws_serverless_express_proxy.id}"
  http_method = "${aws_api_gateway_method.aws_serverless_express_proxy.http_method}"
  status_code = "${aws_api_gateway_method_response.aws_serverless_express_proxy.status_code}"
  depends_on = ["aws_api_gateway_integration.aws_serverless_express_proxy"]
}

/**
 * Create the ANY Method Response for status 200.
 */
resource "aws_api_gateway_method_response" "aws_serverless_express_proxy" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.aws_serverless_express_proxy.id}"
  http_method = "${aws_api_gateway_method.aws_serverless_express_proxy.http_method}"
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}

/**
 * Module dependencies
 * -------------------------------------------------------------------------------------------------------------------
 */

/**
 * Create an indicator resource signaling the readyness to deploy the REST API.
 */
resource "null_resource" "module_dependency" {
  depends_on = [
    "aws_api_gateway_resource.aws_serverless_express_root",
    "aws_api_gateway_method.aws_serverless_express_root",
    "aws_api_gateway_integration.aws_serverless_express_root",
    "aws_api_gateway_integration_response.aws_serverless_express_root",
    "aws_api_gateway_method_response.aws_serverless_express_root",
    "aws_api_gateway_resource.aws_serverless_express_proxy",
    "aws_api_gateway_method.aws_serverless_express_proxy",
    "aws_api_gateway_integration.aws_serverless_express_proxy",
    "aws_api_gateway_integration_response.aws_serverless_express_proxy",
    "aws_api_gateway_method_response.aws_serverless_express_proxy"
  ]
}
