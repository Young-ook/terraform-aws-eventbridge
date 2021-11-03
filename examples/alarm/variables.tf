# Variables for providing to module fixture codes

### network
variable "aws_region" {
  description = "The aws region to deploy"
  type        = string
  default     = "us-east-1"
}

### alarm
variable "alarm_config" {
  description = "Alarm configuration for cloudwatch alarm"
  type        = map(any)
  default     = {}
}

variable "metric_query" {
  description = "Alarm metric query configurations"
  type        = list(any)
  default     = []
}

### description
variable "name" {
  description = "The logical name of the module instance"
  type        = string
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
