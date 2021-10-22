# AWS Lambda for event-driven architecture example

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

# events
resource "aws_cloudwatch_event_rule" "rules" {
  name                = join("-", [var.name, "cron"])
  schedule_expression = "cron(0 20 * * ? *)"
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule = aws_cloudwatch_event_rule.rules.name
  arn  = module.lambda.function.arn
}

resource "aws_lambda_permission" "lambda" {
  source_arn    = aws_cloudwatch_event_rule.rules.arn
  function_name = module.lambda.function.id
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
}

# lambda
module "lambda" {
  source         = "../../"
  name           = var.name
  tags           = var.tags
  lambda_config  = var.lambda_config
  tracing_config = var.tracing_config
  vpc_config     = var.vpc_config
  policy_arns    = [module.logs.policy_arns["write"]]
}

# cloudwatch logs
module "logs" {
  source     = "Young-ook/lambda/aws//modules/logs"
  name       = var.name
  log_config = var.log_config
}
