### table
variable "attributes" {
  description = "List of nested attribute definitions. (https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/HowItWorks.CoreComponents.html)"
  type        = list(map(string))
  default     = []
}

variable "key_schema" {
  description = "The key schema to describe the the partition key and the sort key"
  type        = map(any)
}

variable "global_secondary_indices" {
  description = "Global Secondary Indices (GSI) for the table"
  type        = list(any)
  default     = []
}

variable "local_secondary_indices" {
  description = "Local Secondary Indices (LSI) on the table"
  type        = list(any)
  default     = []
}

variable "billing_mode" {
  description = "Configuration for billing mode to contorl how to adjust the read/write throughput and how you manage capacity"
  type        = string
  default     = "PAY_PER_REQUEST"
  validation {
    condition     = contains(["PROVISIONED", "PAY_PER_REQUEST"], var.billing_mode)
    error_message = "The valid values are PROVISIONED or PAY_PER_REQUEST."
  }
}

variable "scaling" {
  description = "DynamoDB autoscaling configuration"
  type        = map(any)
  default = {
    min_read_capacity  = 5
    max_read_capacity  = 10
    target_read        = 70
    min_write_capacity = 5
    max_write_capacity = 10
    target_write       = 70
  }
}

variable "server_side_encryption" {
  description = "Server side encryption (SSE) configuration"
  type        = map(any)
  default     = {}
}

variable "point_in_time_recovery" {
  description = "Point-in-time recovery configuration"
  type        = bool
  default     = false
}

variable "ttl" {
  description = "TTL attribute"
  type        = map(any)
  default = {
    enabled   = "true"
    attribute = "Expires"
  }
}

### description
variable "name" {
  description = "DynamoDB table name"
  type        = string
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
