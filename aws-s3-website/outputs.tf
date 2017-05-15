output "bucket_domain_name" {
  value = "${aws_s3_bucket.aws_s3_website.bucket_domain_name}"
}
output "website_endpoint" {
  value = "${aws_s3_bucket.aws_s3_website.website_endpoint}"
}
