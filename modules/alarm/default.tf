# default variables

locals {
  default_alarm_config = {
    threshold                             = 1
    treat_missing_data                    = "missing"
    datapoints_to_alarm                   = null
    evaluate_low_sample_count_percentiles = null
    evaluation_periods                    = 1

    # comparison_operator. following is supported:
    #   GreaterThanOrEqualToThreshold
    #   GreaterThanThreshold
    #   LessThanThreshold
    #   LessThanOrEqualToThreshold
    comparison_operator = "GreaterThanThreshold"
  }
  default_alarm_actions_config = {
    enabled                   = false
    alarm_actions             = []
    ok_actions                = []
    insufficient_data_actions = []
  }
  default_metric_query = {
    label       = null
    return_data = false
    expression  = null
    metric      = []
  }
}
