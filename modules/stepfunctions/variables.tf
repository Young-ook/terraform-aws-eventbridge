### state machine flow
variable "workflow" {
  description = "State machine workflow definitions"
  type        = map(any)
  default     = {}
}

### security
variable "policy_arns" {
  description = "Policy ARNs to attach to the step functions state machine"
  type        = list(string)
  default     = []
}

### tracing
variable "tracing" {
  description = "Tracing configuration for Step Functions"
  type        = map(any)
  default     = {}
}

### description
variable "name" {
  description = "Step Functions name"
  type        = string
  default     = null
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
