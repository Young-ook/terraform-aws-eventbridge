# default variables

locals {
  default_log_config = {
    namespace      = "/aws"
    retention_days = 7
  }
}
