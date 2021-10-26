# Variables for providing to module fixture codes

### network
variable "aws_region" {
  description = "The aws region to deploy"
  type        = string
  default     = "us-east-1"
}

### log
variable "log_config" {
  description = "Log configuration for function"
  type        = map(any)
  default     = {}
}

variable "namespace" {
  description = "The prefix of log group (e.g., /aws/lambda)"
  type        = string
  default     = null
}

variable "log_metric_filters" {
  description = "Log metric tranform filters"
  type        = list(any)
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
