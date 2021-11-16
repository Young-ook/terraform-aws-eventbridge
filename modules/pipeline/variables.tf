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
  description = "Name of metric alarm. This name must be unique within the AWS account"
  type        = string
  default     = ""
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
