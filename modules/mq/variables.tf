### network
variable "vpc" {
  description = "A Virtual Private Cloud (VPC) configuration"
  default     = {}
}

### message queue
variable "mq" {
  description = "Message queue broker configuration"
  default     = {}
}

### description
variable "name" {
  description = "Message queue name"
  type        = string
  default     = null
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
