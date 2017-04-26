/**
 * Route53
 * -------------------------------------------------------------------------------------------------------------------
 */

/**
 * Set of nameservers used for the platform domain.
 */
resource "aws_route53_delegation_set" "Platform" {
  reference_name = "${var.environment}"
}

/**
 * Hosted zone used for the platform domain.
 */
resource "aws_route53_zone" "Platform" {
  name = "${var.platform_domain}"
  delegation_set_id = "${aws_route53_delegation_set.Platform.id}"
}

/**
 * CNAME record used by the email provider to verfify the domain ownership.
 */
resource "aws_route53_record" "PlatformMailVerification" {
  zone_id = "${aws_route53_zone.Platform.zone_id}"
  name = "${var.email_domain_verification_cname_name}"
  type = "CNAME"
  ttl = "300"
  records = [
    "${var.email_domain_verification_cname_value}"]
}

/**
 * MX record pointing to the email provider.
 */
resource "aws_route53_record" "PlatformMail" {
  zone_id = "${aws_route53_zone.Platform.zone_id}"
  name = "${aws_route53_zone.Platform.name}"
  type = "MX"
  ttl = "300"
  records = ["${var.email_mx_records}"]
}
