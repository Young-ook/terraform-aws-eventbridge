resource "aws_cloudwatch_metric_alarm" "alarm" {
  alarm_name        = local.name
  alarm_description = var.description
  tags              = merge(local.default-tags, var.tags)

  # alarm condition
  comparison_operator                   = lookup(var.alarm_config, "comparison_operator", local.default_alarm_config.comparison_operator)
  threshold                             = lookup(var.alarm_config, "threshold", local.default_alarm_config.threshold)
  treat_missing_data                    = lookup(var.alarm_config, "treat_missing_data", local.default_alarm_config.treat_missing_data)
  datapoints_to_alarm                   = lookup(var.alarm_config, "datapoints_to_alarm", local.default_alarm_config.datapoints_to_alarm)
  evaluation_periods                    = lookup(var.alarm_config, "evaluation_periods", local.default_alarm_config.evaluation_periods)
  evaluate_low_sample_count_percentiles = lookup(var.alarm_config, "evaluate_low_sample_count_percentiles", local.default_alarm_config.evaluate_low_sample_count_percentiles)

  # alarm actions
  actions_enabled           = lookup(var.alarm_actions_config, "actions_enabled", local.default_alarm_actions_config.enabled)
  alarm_actions             = lookup(var.alarm_actions_config, "alarm_actions", local.default_alarm_actions_config.alarm_actions)
  ok_actions                = lookup(var.alarm_actions_config, "ok_actions", local.default_alarm_actions_config.ok_actions)
  insufficient_data_actions = lookup(var.alarm_actions_config, "insufficient_data_actions", local.default_alarm_actions_config.insufficient_data_actions)

  # metric query
  dynamic "metric_query" {
    for_each = var.metric_query
    content {
      id          = lookup(metric_query.value, "id")
      label       = lookup(metric_query.value, "label", local.default_metric_query.label)
      return_data = lookup(metric_query.value, "return_data", local.default_metric_query.return_data)
      expression  = lookup(metric_query.value, "expression", local.default_metric_query.expression)

      dynamic "metric" {
        for_each = lookup(metric_query.value, "metric", local.default_metric_query.metric)
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
