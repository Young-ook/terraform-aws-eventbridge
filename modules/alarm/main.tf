resource "aws_cloudwatch_metric_alarm" "alarm" {
  alarm_name        = local.name
  alarm_description = var.description
  tags              = merge(local.default-tags, var.tags)

  # alarm condition
  comparison_operator                   = lookup(local.alarm_metric, "comparison_operator", "GreaterThanThreshold")
  threshold                             = lookup(local.alarm_metric, "threshold", 1)
  treat_missing_data                    = lookup(local.alarm_metric, "treat_missing_data", "missing")
  datapoints_to_alarm                   = lookup(local.alarm_metric, "datapoints_to_alarm", null)
  evaluation_periods                    = lookup(local.alarm_metric, "evaluation_periods", 1)
  evaluate_low_sample_count_percentiles = lookup(local.alarm_metric, "evaluate_low_sample_count_percentiles", null)

  # alarm actions
  actions_enabled           = lookup(var.alarm_actions, "actions_enabled", false)
  alarm_actions             = lookup(var.alarm_actions, "alarm_actions", [])
  ok_actions                = lookup(var.alarm_actions, "ok_actions", [])
  insufficient_data_actions = lookup(var.alarm_actions, "insufficient_data_actions", [])

  # metric query
  dynamic "metric_query" {
    for_each = local.metric_query
    content {
      id          = lookup(metric_query.value, "id")
      label       = lookup(metric_query.value, "label", null)
      return_data = lookup(metric_query.value, "return_data", false)
      expression  = lookup(metric_query.value, "expression", null)

      dynamic "metric" {
        for_each = lookup(metric_query.value, "metric", [])
        content {
          metric_name = lookup(metric.value, "metric_name")
          namespace   = lookup(metric.value, "namespace")
          period      = lookup(metric.value, "period")
          stat        = lookup(metric.value, "stat")
          unit        = lookup(metric.value, "unit", null)
          dimensions  = lookup(metric.value, "dimensions", null)
        }
      }
    }
  }
}
