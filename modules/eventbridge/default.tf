# default variables

locals {
  default_rule = {
    schedule_expression = null
    event_pattern       = null
  }
  default_bus = {
    event_source_name = null
  }
  bus = var.bus == null ? {} : var.bus
}
