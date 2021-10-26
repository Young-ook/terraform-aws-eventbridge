### log-group
variable "log_config" {
  description = "Log group configuration"
  type        = map(any)
  default     = {}
}

variable "log_metric_filters" {
  description = "Log metric tranform filters"
  type        = list(any)
  default     = []
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
