# Variables for providing to module fixture codes

### network
variable "aws_region" {
  description = "The aws region to deploy"
  type        = string
  default     = "us-east-1"
}

### alarm
variable "alarm_metric" {
  description = "Alarm configuration for cloudwatch alarm"
  type        = any
}

variable "metric_query" {
  description = "Alarm metric query configurations"
  type        = any
}

### description
variable "name" {
  description = "The logical name of the module instance"
  type        = string
  default     = null
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
