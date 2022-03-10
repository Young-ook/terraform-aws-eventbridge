# default variables

locals {
  log_group = var.log_group == null ? {} : var.log_group
}
