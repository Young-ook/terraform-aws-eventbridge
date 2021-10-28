### metric alarm
variable "alarm_config" {
  description = "Metric alarm configuration"
  type        = map(any)
  default     = {}
}

variable "alarm_actions_config" {
  description = "Metric alarm actions configuration"
  type        = map(any)
  default     = {}
}

variable "metric_query" {
  description = "Enables you to create an alarm based on a metric math expression. You may specify at most 20."
  type        = any
  default     = []
}

### description
variable "name" {
  description = "Name of metric alarm. This name must be unique within the AWS account"
  type        = string
  default     = ""
}

variable "description" {
  description = "The description for the alarm."
  type        = string
  default     = null
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
