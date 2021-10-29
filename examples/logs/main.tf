# AWS CloudWatch Logs example

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

# cloudwatch logs
module "logs" {
  source             = "../../modules/logs"
  name               = var.name
  log_config         = var.log_config
  log_metric_filters = var.log_metric_filters
}

# cloudwatch alarm
module "alarm" {
  source      = "../../modules/alarm"
  name        = join("-", [var.name, module.logs.log_metric_filters.0.name])
  description = "Log errors are too high"

  alarm_config = {
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = 1
    threshold           = 10
  }

  metric_query = [
    {
      id = "error_count"
      return_data = true
      metric = [
        {
          metric_name = module.logs.log_metric_filters.0.metric_transformation.0.name
          namespace   = module.logs.log_metric_filters.0.metric_transformation.0.namespace
          period      = "60"
          stat        = "Sum"
          unit        = "Count"
        },
      ]
    }
  ]
}
