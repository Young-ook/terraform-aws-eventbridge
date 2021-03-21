aws_region = "ap-northeast-2"
name       = "lambda-tc1"
tags = {
  env  = "dev"
  test = "tc1"
}

lambda_config = {
  package = "lambda_handler.zip"
  handler = "lambda_handler.lambda_handler"
}

log_config = {
  retension_days = 5
}
