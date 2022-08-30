# Variables for providing to module fixture codes

### network
variable "aws_region" {
  description = "The aws region to deploy"
  type        = string
  default     = "us-east-1"
}

variable "vpc_config" {
  description = "VPC configuration for function"
  type        = map(any)
  default     = {}
}

### code pipeline
variable "artifact_config" {
  description = "Pipeline artifact configuration"
  #  type        = list(object({}))
  default = []
}

variable "stage_config" {
  description = "List of pipeline stage configuration"
  default     = []
}

### log
variable "log_config" {
  description = "Log configuration for function"
  type        = map(any)
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
