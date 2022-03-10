aws_region  = "ap-northeast-2"
name        = "cwlogs-tc2-alb"
description = "This metric monitors HTTP 502 response from backed ec2 instances"
tags = {
  env  = "dev"
  test = "tc2"
}
alarm_metric = {
  # comparison_operator. following is supported:
  #   GreaterThanOrEqualToThreshold
  #   GreaterThanThreshold
  #   LessThanThreshold
  #   LessThanOrEqualToThreshold
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 10
}
metric_query = [
  {
    id          = "elb_num_of_http502"
    return_data = true
    metric = [
      {
        metric_name = "HTTPCode_ELB_502_Count"
        namespace   = "AWS/ApplicationELB"
        period      = "60"
        stat        = "Sum"
        dimensions = {
          LoadBalancer = "MyLB"
        }
      },
    ]
  },
]
