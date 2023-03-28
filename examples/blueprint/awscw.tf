### observability/alarm
module "alarm" {
  source      = "Young-ook/eventbridge/aws//modules/alarm"
  version     = "0.0.8"
  name        = join("-", [module.logs["alarm"].log_group.name, module.logs["alarm"].log_metric_filters.0.name])
  description = "Log errors are too high"

  alarm_metric = {
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 1
    threshold           = 10
  }
  metric_query = [
    {
      id          = "error_count"
      return_data = true
      metric = [
        {
          metric_name = module.logs["alarm"].log_metric_filters.0.metric_transformation.0.name
          namespace   = module.logs["alarm"].log_metric_filters.0.metric_transformation.0.namespace
          period      = "60"
          stat        = "Sum"
          unit        = "Count"
        },
      ]
    }
  ]
}

### observability/logs
module "logs" {
  source  = "Young-ook/eventbridge/aws//modules/logs"
  version = "0.0.8"
  for_each = { for log in [
    {
      type = "alarm"
      log_group = {
        retension_days = 3
      }
      log_metric_filters = [
        {
          pattern   = "ERROR"
          name      = "ErrorCount"
          namespace = "MyApp"
        },
      ]
    },
  ] : log.type => log }
  name               = join("-", ["logs", each.key])
  log_group          = lookup(each.value, "log_group")
  log_metric_filters = lookup(each.value, "log_metric_filters")
}
