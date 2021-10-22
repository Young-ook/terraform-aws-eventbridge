# AWS Lambda function example

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

# lambda
module "lambda" {
  source         = "Young-ook/lambda/aws"
  name           = var.name
  tags           = var.tags
  lambda_config  = var.lambda_config
  tracing_config = var.tracing_config
  vpc_config     = var.vpc_config
  policy_arns    = [module.logs.policy_arns["write"]]
}

# lambda invokation for test
data "aws_lambda_invocation" "invoke" {
  depends_on    = [module.lambda]
  function_name = var.name
  input = jsonencode({
    key1 = "value1"
    key2 = "value2"
    key3 = "value3"
  })
}

# cloudwatch logs
module "logs" {
  source     = "Young-ook/lambda/aws//modules/logs"
  name       = var.name
  log_config = var.log_config
}
