variable "enabled" {
  description = "A conditional indicator to enable"
  type        = bool
  default     = true
}

### computing/function
variable "lambda_config" {
  description = "Lambda function configuration"
  default     = {}
}

### computing/layer
variable "layer_config" {
  description = "Lambda layer configuration"
  type        = map(any)
  default     = {}
}

### network
variable "vpc_config" {
  description = "VPC configuration for function"
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
