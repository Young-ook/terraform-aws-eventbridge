# default variables

locals {
  default_log_config = {
    namespace      = "/aws"
    retention_days = 7
  }
  default_log_metric_filter = {
    name          = null
    namespace     = null
    value         = 1
    default_value = null
  }
}
