### network
variable "vpc" {
  description = "A Virtual Private Cloud (VPC) configuration"
  default     = {}
}

### kafka
variable "msk" {
  description = "Kafka cluster configuration"
  default     = {}
}

### log
variable "log" {
  description = "Log configuration for Kafka cluster"
  default     = {}
}

### description
variable "name" {
  description = "Kafka cluster name"
  type        = string
  default     = null
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
