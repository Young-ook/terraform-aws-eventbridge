### security
variable "policy_arns" {
  description = "Policy ARNs to attach to the step functions state machine"
  type        = list(string)
  default     = []
}

### state machine flow
variable "sfn_config" {
  description = "Step functions state machine configuration"
  type        = map(any)
  default     = {}
}

### tracing
variable "tracing_config" {
  description = "AWS X-ray tracing configuration for step functions"
  type        = map(any)
  default     = {}
}

### description
variable "name" {
  description = "Name of metric alarm. This name must be unique within the AWS account"
  type        = string
  default     = null
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
