# default variables

locals {
  default_rule = {
    schedule_expression = null
    event_pattern       = null
  }
  default_bus = {
    event_source_name = null
  }
  rule = var.rule == null ? {} : var.rule
  bus  = var.bus == null ? {} : var.bus
}
