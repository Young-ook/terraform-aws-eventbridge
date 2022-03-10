aws_region = "ap-northeast-2"
name       = "cwlogs-tc1-custom-config"
tags = {
  env  = "dev"
  test = "tc1"
}
log_group = {
  namespace      = "/aws/codebuild"
  retension_days = 5
}
