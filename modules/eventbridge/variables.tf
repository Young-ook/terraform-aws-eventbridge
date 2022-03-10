### event bridge
variable "bus" {
  description = "Event bus configuration"
  default     = {}
}

variable "rule" {
  description = "Event rule configuration"
  default     = {}
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
