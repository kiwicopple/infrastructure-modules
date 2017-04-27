/**
 * Route53
 * -------------------------------------------------------------------------------------------------------------------
 */

/**
 * Set of nameservers used for the platform domain.
 */
resource "aws_route53_delegation_set" "platform" {
  reference_name = "${var.environment}"
}

/**
 * Hosted zone used for the platform domain.
 */
resource "aws_route53_zone" "platform" {
  name = "${var.platform_domain_name}"
  delegation_set_id = "${aws_route53_delegation_set.platform.id}"
}

/**
 * CNAME record used by the email provider to verfify the domain ownership.
 */
resource "aws_route53_record" "platform_mail_verification" {
  zone_id = "${aws_route53_zone.platform.zone_id}"
  name = "${var.email_domain_verification_cname_name}"
  type = "CNAME"
  ttl = "300"
  records = [
    "${var.email_domain_verification_cname_value}"]
}

/**
 * MX record pointing to the email provider.
 */
resource "aws_route53_record" "platform_mail" {
  zone_id = "${aws_route53_zone.platform.zone_id}"
  name = "${aws_route53_zone.platform.name}"
  type = "MX"
  ttl = "300"
  records = ["${var.email_mx_records}"]
}
