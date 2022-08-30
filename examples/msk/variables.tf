# Variables for providing to module fixture codes

### network
variable "aws_region" {
  description = "The aws region to deploy"
  type        = string
  default     = "us-east-1"
}

variable "vpc_config" {
  description = "VPC configuration for function"
  default     = {}
}

### queue
variable "msk_config" {
  description = "Managed Kafka cluster configuration"
  default     = {}
}

### log
variable "log_config" {
  description = "Log configuration for function"
  default     = {}
}

### description
variable "name" {
  description = "The logical name of the module instance"
  type        = string
  default     = null
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
