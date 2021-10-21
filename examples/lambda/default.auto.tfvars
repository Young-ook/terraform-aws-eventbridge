aws_region = "ap-northeast-2"
name       = "lambda"
tags = {
  env = "dev"
}

lambda_config = {
  package = "lambda_handler.zip"
  handler = "lambda_handler.lambda_handler"
  environment_variables = {
    ENV1 = "value1"
    ENV2 = "value2"
  }
}

log_config = {
  retension_days = 5
}