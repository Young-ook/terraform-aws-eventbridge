aws_region = "ap-northeast-2"
name       = "lambda-event-driven-tc1"
tags = {
  env  = "dev"
  test = "tc1"
}
event_config = {
  cron = {
    rule_config = {
      schedule_expression = "cron(0 20 * * ? *)"
    }
  }
}
log_config = {
  retension_days = 5
}
