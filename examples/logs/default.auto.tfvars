aws_region = "ap-northeast-2"
name       = "cwlogs"
tags = {
  env = "dev"
}
log_metric_filters = [
  {
    pattern   = "ERROR"
    name      = "ErrorCount"
    namespace = "MyApp"
  },
]
