aws_region = "ap-northeast-2"
azs        = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
name       = "lambda-vpc"
tags = {
  env = "dev"
}
lambda_config = {
  package = "lambda_handler.zip"
  handler = "lambda_handler.lambda_handler"
}
tracing_config = {}
log_config = {
  retension_days = 5
}
