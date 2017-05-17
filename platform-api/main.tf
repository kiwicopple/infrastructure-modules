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
  binary_media_types = [
    "text/html",
    "application/json"]
}

/**
 * REST API Deployment for the Platform.
 */
resource "aws_api_gateway_deployment" "platform_api" {
  rest_api_id = "${aws_api_gateway_rest_api.platform_api.id}"
  stage_name = "${var.stage_name}"
  stage_description = "${var.stage_description}"
  depends_on = [
    "aws_api_gateway_rest_api.platform_api",
    "module.platform_api_website",
    "module.platform_api_graphql"]
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
 * S3
 * -------------------------------------------------------------------------------------------------------------------
 */

/**
 * Create the S3 Bucket and Endpoint for the Platform Resources. TODO Files need to be copied manually at the moment.
 */
module "platform_bucket_website_resources" {
  source = "git::git@github.com:wessels-nz/infrastructure-modules.git//aws-s3-website"
  bucket_name = "${var.domain_name}"
}

/**
 * CloudFront
 * -------------------------------------------------------------------------------------------------------------------
 */

/**
 * Create the CloudFront Distribution for the Platform Website.
*/
resource "aws_cloudfront_distribution" "PlatformDistribution" {
  enabled = true
  comment = "Managed by Terraform"
  aliases = [
    "${var.domain_name}",
    "www.${var.domain_name}"
  ]
  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD"
    ]
    cached_methods = [
      "GET",
      "HEAD"
    ]
    compress = true
    default_ttl = 30
    forwarded_values {
      cookies {
        forward = "none"
      }
      query_string = false
    }
    max_ttl = 86400
    min_ttl = 0
    target_origin_id = "platform_api_website"
    viewer_protocol_policy = "redirect-to-https"
  }
  cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD"]
    cached_methods = [
      "GET",
      "HEAD"]
    compress = true
    default_ttl = 30
    "forwarded_values" {
      "cookies" {
        forward = "none"
      }
      query_string = false
    }
    max_ttl = 86400
    min_ttl = 0
    path_pattern = "_/*"
    target_origin_id = "platform_s3_website"
    viewer_protocol_policy = "redirect-to-https"
  }
  origin {
    domain_name = "${aws_api_gateway_rest_api.platform_api.id}.execute-api.${var.region}.amazonaws.com"
    origin_id = "platform_api_website"
    origin_path = "/${var.stage_name}"
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = [
        "TLSv1",
        "TLSv1.1",
        "TLSv1.2"]
    }
  }
  origin {
    domain_name = "${module.platform_bucket_website_resources.bucket_domain_name}"
    origin_id = "platform_s3_website"
  }
  price_class = "PriceClass_All"
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn = "${var.domain_certificate_arn}"
    minimum_protocol_version = "TLSv1"
    ssl_support_method = "sni-only"
  }
  retain_on_delete = true
}
