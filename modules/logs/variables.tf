### log-group
variable "namespace" {
  description = "Namespace of log group"
  type        = string
  default     = "/aws/lambda"
}

variable "log_config" {
  description = "Log group configuration"
  type        = map(any)
  default     = {}
}

### description
variable "name" {
  description = "Name of container image repository"
  type        = string
  default     = ""
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
