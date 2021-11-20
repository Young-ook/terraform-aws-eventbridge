### network
variable "vpc_config" {
  description = "A Virtual Private Cloud (VPC) configuration"
  default     = {}
}

### kafka
variable "cluster_config" {
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