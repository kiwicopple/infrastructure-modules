/**
 * CloudFront
 * -------------------------------------------------------------------------------------------------------------------
 */

/**
 * CloudFront distribution for the platform domain.
 */
resource "aws_cloudfront_distribution" "PlatformDistribution" {
  enabled = true
  comment = "Managed by Terraform"
  aliases = [
    "${var.aliases}"
  ]
  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD"]
    cached_methods = [
      "GET",
      "HEAD"]
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
    target_origin_id = "${var.root_origin_id}"
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
    path_pattern = "/resources"
    target_origin_id = "${var.resource_origin_id}"
    viewer_protocol_policy = "redirect-to-https"
  }
  origin {
    domain_name = "${var.root_origin_domain_name}"
    origin_id = "${var.root_origin_id}"
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
    domain_name = "${var.resource_origin_domain_name}"
    origin_id = "${var.resource_origin_id}"
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = [
        "TLSv1",
        "TLSv1.1",
        "TLSv1.2"]
    }
//    s3_origin_config {
//      origin_access_identity = "${aws_cloudfront_origin_access_identity.PlatformDistribution.cloudfront_access_identity_path}"
//    }
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

/**
 * Origin Identity to workaround https://github.com/hashicorp/terraform/issues/7930
 */
resource "aws_cloudfront_origin_access_identity" "PlatformDistribution" {
  comment = "Managed by Terraform"
}
