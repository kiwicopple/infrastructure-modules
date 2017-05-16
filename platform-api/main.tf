/**
 * API Gateway
 * -------------------------------------------------------------------------------------------------------------------
 */

/**
 * REST API for the Platform.
 */
resource "aws_api_gateway_rest_api" "platform_api" {
  name = "platform_api"
  description = "Platform API"
  binary_media_types = ["text/html", "application/json"]
}

/**
 * REST API Deployment for the Platform.
 */
resource "aws_api_gateway_deployment" "platform_api" {
  rest_api_id = "${aws_api_gateway_rest_api.platform_api.id}"
  stage_name = "${var.stage_name}"
  stage_description = "${var.stage_description}"
  depends_on = ["aws_api_gateway_rest_api.platform_api"]
}

///**
// * Create the Website endpoint for the Platform API.
// */
//module "serverless_express_endpoint" {
//  count = 2
//  source = "git::git@github.com:wessels-nz/infrastructure-modules.git//aws-serverless-express"
//  region = "${var.region}"
//  filename = "${null_resource.serverless_express[count.index].filename}"
//  function_name = "${null_resource.serverless_express[count.index].function_name}"
//  role_arn = "${null_resource.serverless_express[count.index].role_arn}"
//  handler = "${null_resource.serverless_express[count.index].handler}"
//  runtime = "${null_resource.serverless_express[count.index].runtime}"
//  create_child_resource = "${null_resource.serverless_express[count.index].create_child_resource}"
//  child_resource_path = "${null_resource.serverless_express[count.index].child_resource_path}"
//  rest_api_id = "${aws_api_gateway_rest_api.platform_api.id}"
//  rest_api_parent_resource_id = "${aws_api_gateway_rest_api.platform_api.root_resource_id}"
//}

resource "null_resource" "serverless_express" {
  count = 2
  triggers {
    filename = "${var.serverless_express_endpoints.*.filename}"
    function_name = "${var.serverless_express_endpoints.*.function_name}"
    role_arn = "${var.serverless_express_endpoints.*.role_arn}"
    handler = "${var.serverless_express_endpoints.*.handler}"
    runtime = "${var.serverless_express_endpoints.*.runtime}"
    create_child_resource = "${var.serverless_express_endpoints.*.create_child_resource}"
    child_resource_path = "${var.serverless_express_endpoints.*.child_resource_path}"
  }
}
