# default variables

locals {
  alarm_metric = var.alarm_metric == null ? {} : var.alarm_metric
  metric_query = var.metric_query == null ? [] : var.metric_query
}
