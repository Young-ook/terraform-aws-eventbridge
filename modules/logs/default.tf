# default variables

locals {
  log_config = var.log_config == null ? {} : var.log_config
}

locals {
  default_log_config = {
    namespace      = "/default"
    retention_days = 7
  }
  default_log_metric_filter = {
    name          = null
    namespace     = null
    value         = 1
    default_value = null
  }
}
