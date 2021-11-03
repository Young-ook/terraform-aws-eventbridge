# default variables

locals {
  rule_config = var.rule_config == null ? {} : var.rule_config
  bus_config  = var.bus_config == null ? {} : var.bus_config
}

locals {
  default_rule_config = {}
  default_bus_config = {
    name              = "default"
    event_source_name = null
  }
}
