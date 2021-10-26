aws_region = "ap-northeast-2"
name       = "cwlogs-tc1-custom-config"
tags = {
  env  = "dev"
  test = "tc1"
}
log_config = {
  namespace      = "/aws/codebuild"
  retension_days = 5
}
log_metric_filters = [
  {
    pattern   = "ERROR"
    name      = "ErrorCount"
    namespace = "MyApp"
  },
]
