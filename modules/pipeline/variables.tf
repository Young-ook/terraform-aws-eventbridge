### security
variable "policy_arns" {
  description = "Policy ARNs to attach to the code pipeline"
  type        = list(string)
  default     = []
}

### code pipeline
variable "artifacts" {
  description = "Pipeline artifact store configuration"
  default     = []
}

variable "stages" {
  description = "List of pipeline stage configuration"
  default     = []
}

### description
variable "name" {
  description = "Pipeline name"
  type        = string
  default     = null
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
