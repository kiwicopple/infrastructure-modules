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
variable "serverless_express_endpoints" {
  type = "list"
  description = ""
}
