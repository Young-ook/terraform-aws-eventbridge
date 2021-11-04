aws_region = "ap-northeast-2"
name       = "cwlogs-tc3-custom-config-with-ns"
tags = {
  env  = "dev"
  test = "tc3"
}
log_config = {
  retension_days = 5
}
