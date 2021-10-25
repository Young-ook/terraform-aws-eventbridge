aws_region = "ap-northeast-2"
name       = "cwlogs-tc1-custom-config"
tags = {
  env  = "dev"
  test = "tc1"
}
namespace = "/aws/codebuild"
log_config = {
  retension_days = 5
}
