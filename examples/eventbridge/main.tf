# AWS Lambda for event-driven architecture example

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

# events
locals {
  event_config = var.event_config == null ? {} : var.event_config
  pattern_event = {
    pattern = {
      rule_config = {
        event_pattern = file("event-pattern-example.json")
      }
    }
  }
  events = merge(local.pattern_event, local.event_config)
}

module "event" {
  for_each    = local.events
  source      = "Young-ook/lambda/aws//modules/events"
  name        = join("-", [var.name, each.key])
  rule_config = each.value.rule_config
}

resource "aws_cloudwatch_event_target" "lambda" {
  for_each = local.events
  rule     = module.event[each.key].eventbridge.rule.name
  arn      = module.lambda.function.arn
}

resource "aws_lambda_permission" "lambda" {
  for_each      = local.events
  source_arn    = module.event[each.key].eventbridge.rule.arn
  function_name = module.lambda.function.id
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
}

# zip arhive
data "archive_file" "lambda_zip_file" {
  output_path = join("/", [path.module, "lambda_handler.zip"])
  source_dir  = join("/", [path.module, "app"])
  excludes    = ["__init__.py", "*.pyc"]
  type        = "zip"
}

# lambda
module "lambda" {
  source = "Young-ook/lambda/aws"
  name   = var.name
  tags   = var.tags
  lambda_config = {
    s3_bucket = module.artifact.bucket.id
    s3_key    = "lambda_handler.zip"
    handler   = "lambda_handler.lambda_handler"
  }
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
