# default variables

locals {
  alarm_config = var.alarm_config == null ? {} : var.alarm_config
  metric_query = var.metric_query == null ? [] : var.metric_query
}
