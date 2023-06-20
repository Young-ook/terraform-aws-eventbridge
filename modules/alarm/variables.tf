### metric alarm
variable "alarm_metric" {
  description = "Metric alarm configuration"
  type        = any
  validation {
    condition     = var.alarm_metric != null && length(var.alarm_metric) > 0
    error_message = "Alarm metric must not be null. also, the length of map should be greater than 0."
  }
}

variable "alarm_actions" {
  description = "Metric alarm actions configuration"
  type        = any
  default     = {}
}

variable "metric_query" {
  description = "Enables you to create an alarm based on a metric math expression. You may specify at most 20."
  type        = any
  validation {
    condition     = var.metric_query != null && length(var.metric_query) > 0
    error_message = "Metric query must not be null. also, the length of list should be greater than 0."
  }
}

### description
variable "name" {
  description = "Alarm name"
  type        = string
  default     = ""
}

variable "description" {
  description = "Alarm description"
  type        = string
  default     = null
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
