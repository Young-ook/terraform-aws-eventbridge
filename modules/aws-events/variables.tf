### event source
variable "rules" {
  description = "Event rules configuration"
  default     = {}
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
  description = "The logical name of user"
  default     = null
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
