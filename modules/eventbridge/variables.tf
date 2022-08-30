### event bridge
variable "bus" {
  description = "Event bus configuration"
  default     = {}
  validation {
    condition     = var.bus != null
    error_message = "Configuration for custom eventbridge bus must not be null."
  }
}

variable "rules" {
  description = "List of event rules configuration"
  default     = []
  validation {
    condition     = var.rules != null && length(var.rules) > 0
    error_message = "List of eventbridge rules is not valid."
  }
}

### description
variable "name" {
  description = "Event bus name"
  type        = string
  default     = null
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
