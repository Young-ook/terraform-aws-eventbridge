# default variables

locals {
  default_rule_config = {
    schedule_expression = null
    event_pattern       = null
  }
  default_bus_config = {
    event_source_name = null
  }
  rule_config = var.rule_config == null ? {} : var.rule_config
  bus_config  = var.bus_config == null ? {} : var.bus_config
}
