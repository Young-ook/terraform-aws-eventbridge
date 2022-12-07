### input variables

### computing/layer
variable "layer" {
  description = "Lambda layer configuration"
  type        = any
  default     = {}
  validation {
    condition     = var.layer != null
    error_message = "Layer configuration must not be null."
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
