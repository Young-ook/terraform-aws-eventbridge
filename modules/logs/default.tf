# default variables

locals {
  log_config = var.log_config == null ? {} : var.log_config
}
