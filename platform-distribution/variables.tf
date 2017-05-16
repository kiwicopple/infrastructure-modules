variable "aliases" {
  type = "list"
  description = "The list of aliases used by the distribution."
  default = []
}
variable "root_origin_id" {
  type = "string"
  description = "The id of the root origin (API Gateway Website Endpoint)."
}
variable "root_origin_domain_name" {
  type = "string"
  description = "The domain name of the root origin (API Gateway Website Endpoint)."
}
variable "root_origin_path" {
  type = "string"
  description = "The domain name of the root origin (API Gateway Website Endpoint)."
}
variable "resource_origin_id" {
  type = "string"
  description = "The id of the root origin (S3 Website Resources Bucket)."
}
variable "resource_origin_domain_name" {
  type = "string"
  description = "The domain name of the root origin (S3 Website Resources Bucket)."
}
variable "domain_certificate_arn" {
  type = "string"
  description = "The arn of the acm domain certificate."
}
