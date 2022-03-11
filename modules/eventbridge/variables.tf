### event bridge
variable "bus" {
  description = "Event bus configuration"
  default     = {}
}

variable "rules" {
  description = "List of Event rules configuration"
  default     = []
  validation {
    condition     = var.rules != null && length(var.rules) > 0
    error_message = "List of eventbridge rules is not valid."
  }
}

### description
variable "name" {
  description = "Name of metric alarm. This name must be unique within the AWS account"
  type        = string
  default     = ""
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
