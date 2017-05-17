variable "region" {
  type = "string"
  description = "The AWS Region for the lambda function."
}
variable "stage_name" {
  type = "string"
  description = "The state name for the API deployment."
}
variable "stage_description" {
  type = "string"
  description = "This is also an indicator that signals that the API is now ready to be deployed."
}
variable "website_lambda_filename" {
  type = "string"
  description = "The full path and filename to the lambda function's zip file."
}
variable "website_lambda_role_arn" {
  type = "string"
  description = "The IAM role ARN for the lambda function."
}
variable "domain_name" {
  type = "string"
  description = "The platform domain name."
}
variable "domain_certificate_arn" {
  type = "string"
  description = "The arn of the acm domain certificate."
}
