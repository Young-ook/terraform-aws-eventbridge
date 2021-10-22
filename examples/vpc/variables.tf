# Variables for providing to module fixture codes

### network
variable "aws_region" {
  description = "The aws region to deploy"
  type        = string
  default     = "us-east-1"
}

variable "cidr" {
  description = "The vpc CIDR (e.g. 10.0.0.0/16)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "A list of availability zones for the vpc to deploy resources"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "vpc_config" {
  description = "VPC configuration for function"
  type        = map(any)
  default     = {}
}

### function
variable "lambda_config" {
  description = "Lambda function configuration"
  default     = {}
}

### log
variable "log_config" {
  description = "Log configuration for function"
  type        = map(any)
  default     = {}
}

### tracing
variable "tracing_config" {
  description = "AWS X-ray tracing configuration for function"
  type        = map(any)
  default     = {}
}

### security
variable "policies" {
  description = "A list of policy ARNs to attach the role for lambda function"
  type        = list(string)
  default     = []
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
