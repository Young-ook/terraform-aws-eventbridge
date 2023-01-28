### input variables

### network
variable "vpc" {
  description = "VPC configuration for function"
  type        = any
  default     = {}
}

### computing/function
variable "lambda" {
  description = "Lambda function configuration"
  type        = any
  default     = {}
  validation {
    condition     = var.lambda != null
    error_message = "Lambda function configuration must not be null."
  }
}

variable "layer" {
  description = "Lambda layer configuration"
  type        = any
  default     = {}
  validation {
    condition     = var.layer != null
    error_message = "Layer configuration must not be null."
  }
}

### observability/tracing
variable "tracing" {
  description = "Tracing configuration for function"
  type        = any
  default     = {}
}

### observability/logs
variable "logs" {
  description = "Log configuration for function"
  type        = any
  default     = {}
}

### security
variable "policy_arns" {
  description = "List of policy ARNs for lambda function"
  type        = list(string)
  default     = []
}

### description
variable "name" {
  description = "Lambda function name"
  type        = string
  default     = null
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
