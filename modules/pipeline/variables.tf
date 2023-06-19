### security
variable "policy_arns" {
  description = "Policy ARNs to attach to the code pipeline"
  type        = list(string)
  default     = []
}

### code pipeline
variable "artifact_config" {
  description = "Pipeline artifact configuration"
  default     = []
}

variable "stage_config" {
  description = "List of pipeline stage configuration"
  default     = []
}

### description
variable "name" {
  description = "Resource name"
  type        = string
  default     = null
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
