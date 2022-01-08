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

### function
variable "lambda_config" {
  description = "Lambda function configuration"
  default     = {}
}

variable "msk_config" {
  description = "Managed Kafka cluster configuration"
  default     = {}
}

### log
variable "log_config" {
  description = "Log configuration for function"
  default     = {}
}

### tracing
variable "tracing_config" {
  description = "AWS X-ray tracing configuration for function"
  type        = map(any)
  default     = {}
}

### security
variable "policy_arns" {
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
