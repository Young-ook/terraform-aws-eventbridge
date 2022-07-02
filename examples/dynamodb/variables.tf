# Variables for providing to module fixture codes

### network
variable "aws_region" {
  description = "The aws region to deploy"
  type        = string
  default     = "us-east-1"
}

variable "vpc_config" {
  description = "VPC configuration for function"
  default     = {}
}

### dynamodb
variable "dynamodb_config" {
  description = "DynamoDB table configuration"
  default     = {}
}

### function
variable "lambda_config" {
  description = "Lambda function configuration"
  default     = {}
}

### observability
variable "cwlog_config" {
  description = "CloudWatch Logs configuration"
  default     = {}
}

variable "tracing_config" {
  description = "X-ray tracing configuration for function"
  type        = map(any)
  default     = {}
}

### description
variable "name" {
  description = "The logical name of the module instance"
  type        = string
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
