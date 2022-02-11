### network
variable "vpc_config" {
  description = "A Virtual Private Cloud (VPC) configuration"
  default     = {}
}

### kafka
variable "msk_config" {
  description = "Kafka cluster configuration"
  default     = {}
}

### log
variable "log_config" {
  description = "Log configuration for Kafka cluster"
  default     = {}
}

### description
variable "name" {
  description = "Name of Kafka cluster"
  type        = string
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
