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
  depends_on = ["aws_api_gateway_rest_api.platform_api", "module.platform_api_website", "module.platform_api_graphql"]
}

/**
 * Create the Website endpoint for the Platform API.
 */
module "platform_api_website" {
  source = "git::git@github.com:wessels-nz/infrastructure-modules.git//aws-serverless-express"
  region = "${var.region}"
  filename = "${var.website_lambda_filename}"
  function_name = "platform-api-website"
  role_arn = "${var.website_lambda_role_arn}"
  handler = "index.handler"
  runtime = "nodejs6.10"
  rest_api_id = "${aws_api_gateway_rest_api.platform_api.id}"
  rest_api_parent_resource_id = "${aws_api_gateway_rest_api.platform_api.root_resource_id}"
  create_child_resource = false
}

/**
 * Create the GraphQL endpoint for the Platform API.
 */
module "platform_api_graphql" {
  source = "git::git@github.com:wessels-nz/infrastructure-modules.git//aws-serverless-express"
  region = "${var.region}"
  filename = "${var.graphql_lambda_filename}"
  function_name = "platform-api-graphql"
  role_arn = "${var.graphql_lambda_role_arn}"
  handler = "index.handler"
  runtime = "nodejs6.10"
  rest_api_id = "${aws_api_gateway_rest_api.platform_api.id}"
  rest_api_parent_resource_id = "${aws_api_gateway_rest_api.platform_api.root_resource_id}"
  create_child_resource = true
  child_resource_path = "graphql"
}

/**
 * Create the S3 Bucket and Endpoint for the Platform Resources. TODO Files need to be copied manually at the moment.
 */
module "platform_bucket_website_resources" {
  source = "git::git@github.com:wessels-nz/infrastructure-modules.git//aws-s3-website"
  bucket_name = "wessels.nz"
}

/**
 * Create the CloudFront Distribution for the Platform Website.
*/
module "platform_distribution" {
  source = "git::git@github.com:wessels-nz/infrastructure-modules.git//platform-distribution"
  aliases = ["${var.domain_name}"]
  root_origin_id = "platform_api_website"
  // https://github.com/hashicorp/terraform/pull/13889
  // "${aws_api_gateway_deployment.platform_api.invoke_url}"
  root_origin_domain_name = "${aws_api_gateway_rest_api.platform_api.id}.execute-api.${var.region}.amazonaws.com/${var.stage_name}"
  resource_origin_id = "platform_s3_website"
  resource_origin_domain_name = "${module.platform_bucket_website_resources.bucket_domain_name}"
  domain_certificate_arn = "${var.domain_certificate_arn}"
}

/**
 * Create the Website endpoint for the Platform API.
 */
//module "serverless_express_endpoint" {
//  count = 2
//  source = "git::git@github.com:wessels-nz/infrastructure-modules.git//aws-serverless-express"
//  region = "${var.region}"
//  filename = "${null_resource.serverless_express.*.filename[count.index]}"
//  function_name = "${null_resource.serverless_express.*.function_name[count.index]}"
//  role_arn = "${null_resource.serverless_express.*.role_arn[count.index]}"
//  handler = "${null_resource.serverless_express.*.handler[count.index]}"
//  runtime = "${null_resource.serverless_express.*.runtime[count.index]}"
//  create_child_resource = "${null_resource.serverless_express.*.create_child_resource[count.index]}"
//  child_resource_path = "${null_resource.serverless_express.*.child_resource_path[count.index]}"
//  rest_api_id = "${aws_api_gateway_rest_api.platform_api.id}"
//  rest_api_parent_resource_id = "${aws_api_gateway_rest_api.platform_api.root_resource_id}"
//}

//module "serverless_express_endpoint" {
//  count = 2
//  source = "git::git@github.com:wessels-nz/infrastructure-modules.git//aws-serverless-express"
//  region = "${var.region}"
//  filename = "${lookup(var.serverless_express_endpoints[count.index], "filename")}"
//  function_name = "${lookup(var.serverless_express_endpoints[count.index], "function_name")}"
//  role_arn = "${lookup(var.serverless_express_endpoints[count.index], "role_arn")}"
//  handler = "${lookup(var.serverless_express_endpoints[count.index], "handler")}"
//  runtime = "${lookup(var.serverless_express_endpoints[count.index], "runtime")}"
//  create_child_resource = "${lookup(var.serverless_express_endpoints[count.index], "create_child_resource")}"
//  child_resource_path = "${lookup(var.serverless_express_endpoints[count.index], "child_resource_path")}"
//  rest_api_id = "${aws_api_gateway_rest_api.platform_api.id}"
//  rest_api_parent_resource_id = "${aws_api_gateway_rest_api.platform_api.root_resource_id}"
//}
//
//resource "null_resource" "serverless_express" {
//  count = 2
//  triggers {
//    filename = "${lookup(var.serverless_express_endpoints[count.index], "filename")}"
//    function_name = "${lookup(var.serverless_express_endpoints[count.index], "function_name")}"
//    role_arn = "${lookup(var.serverless_express_endpoints[count.index], "role_arn")}"
//    handler = "${lookup(var.serverless_express_endpoints[count.index], "handler")}"
//    runtime = "${lookup(var.serverless_express_endpoints[count.index], "runtime")}"
//    create_child_resource = "${lookup(var.serverless_express_endpoints[count.index], "create_child_resource")}"
//    child_resource_path = "${lookup(var.serverless_express_endpoints[count.index], "child_resource_path")}"
//  }
//}
