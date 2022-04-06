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
  description = "Describe a Global Secondary Indices (GSI) for the table"
  type        = list(any)
  default     = []
}

variable "local_secondary_indices" {
  description = "Describe an Local Secondary Indices (LSI) on the table"
  type        = list(any)
  default     = []
}

variable "billing_mode" {
  description = "Controls how you are billed for read/write throughput and how you manage capacity."
  type        = string
  default     = "PAY_PER_REQUEST"
  validation {
    condition     = contains(["PROVISIONED", "PAY_PER_REQUEST"], var.billing_mode)
    error_message = "The valid values are PROVISIONED or PAY_PER_REQUEST."
  }
}

variable "scaling_config" {
  description = "DynamoDB autoscaling configuration"
  type        = map(any)
  default = {
    min_read_capacity  = 5
    min_write_capacity = 5
    max_read_capacity  = 100
    max_write_capacity = 100
    read_target        = 70
    write_target       = 70
  }
}

variable "server_side_encryption" {
  description = "A configuration of server side encryption"
  type        = map(any)
  default     = {}
}

variable "point_in_time_recovery" {
  description = "Indicates whether to enable point-in-time recovery"
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
  description = "The logical name of the module instance"
  type        = string
}

### tags
variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}
