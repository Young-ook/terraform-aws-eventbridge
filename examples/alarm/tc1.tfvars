aws_region  = "ap-northeast-2"
name        = "cwalarm-tc1-containerinsights"
description = "This metric monitors healthy backed pods of a service"
tags = {
  env  = "dev"
  test = "tc1"
}
alarm_config = {
  comparison_operator = "LessThanThreshold"
  datapoints_to_alarm = 1
  evaluation_periods  = 1
  threshold           = 1
}
metric_query = [
  {
    id          = "service_num_of_running_pods"
    return_data = true
    metric = [
      {
        metric_name = "service_number_of_running_pods"
        namespace   = "ContainerInsights"
        period      = "10"
        stat        = "Average"
        #        unit        = "Count"
        dimensions = {
          Namespace   = "sockshop"
          Service     = "front-end"
          ClusterName = "MyCluster"
        }
      },
    ]
  },
]
