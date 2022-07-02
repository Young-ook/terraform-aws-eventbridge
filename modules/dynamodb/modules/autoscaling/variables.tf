### scaling
variable "scaling_policy" {
  description = "DynamoDB autoscaling configuration"
  type        = map(any)
  default = {
    min_capacity           = 5
    max_capacity           = 10
    target_value           = 70
    scalable_dimension     = null
    service_namespace      = null
    policy_type            = "TargetTrackingScaling"
    predefined_metric_type = null
  }
}

### description
variable "name" {
  description = "The logical name of the module instance"
  type        = string
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
