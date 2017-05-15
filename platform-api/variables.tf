variable "stage_name" {
  type = "string"
  description = "The state name for the API deployment."
}

variable "stage_description" {
  type = "string"
  description = "This is also an indicator that signals that the API is now ready to be deployed."
}

variable "serverless_express_endpoint" {
  type = "list"
  description = ""
}
