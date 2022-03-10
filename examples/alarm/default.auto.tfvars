aws_region = "ap-northeast-2"
name       = null
tags = {
  env = "dev"
}
alarm_metric = {
  threshold = 1
}
metric_query = [
  {
    id          = "service_num_of_running_pods"
    return_data = true
    metric = [
      {
        metric_name = "CPUUtilization"
        namespace   = "AWS/EC2"
        period      = "60"
        stat        = "Average"
        dimensions = {
          AutoScalingGroupName = "MyASG"
        }
      },
    ]
  },
]
