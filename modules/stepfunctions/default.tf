# default variables

locals {
  sfn_config     = var.sfn_config == null ? {} : var.sfn_config
  tracing_config = var.tracing_config == null ? {} : var.tracing_config
}
