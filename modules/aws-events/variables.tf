### event source
variable "rules" {
  description = "Event rules configuration"
  default     = []
  validation {
    condition     = var.rules != null
    error_message = "List of eventbridge rules is not valid."
  }
}

### network
variable "vpc" {
  description = "VPC configuration for function"
  default     = {}
}

### compute
variable "lambda" {
  description = "Lambda function configuration"
  default     = {}
}

### description
variable "name" {
  description = "Construct library instance name"
  default     = null
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
