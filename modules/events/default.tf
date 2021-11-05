# default variables

locals {
  rule_config = var.rule_config == null ? {} : var.rule_config
  bus_config  = var.bus_config == null ? {} : var.bus_config
}
