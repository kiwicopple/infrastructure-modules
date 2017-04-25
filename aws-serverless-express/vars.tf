variable "region" {
  type = "string"
  description = "The AWS Region for the lambda function."
}
variable "filename" {
  type = "string"
  description = "The full path and filename to the lambda function's zip file."
}
variable "function_name" {
  type = "string"
  description = "The name of the lamda funtion."
}
variable "role_arn" {
  type = "string"
  description = "The IAM role ARN for the lambda function."
}
variable "rest_api_id" {
  type = "string"
  description = "The ID of the APIGateway REST API that provides the endpoint to the lambda function."
}
variable "rest_api_parent_resource_id" {
  type = "string"
  description = "The ID of the APIGateway REST API parent resource."
}
