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

resource "aws_cloudwatch_event_target" "sfn" {
  for_each = local.events
  rule     = module.event[each.key].eventbridge.rule.name
  arn      = module.sfn.states.arn
  role_arn = aws_iam_role.invoke-sfn.arn
}

module "aws" {
  source = "Young-ook/spinnaker/aws//modules/aws-partitions"
}

resource "aws_iam_role" "invoke-sfn" {
  name = join("-", [var.name, "invoke-sfn"])
  tags = var.tags
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = format("events.%s", module.aws.partition.dns_suffix)
      }
    }]
    Version = "2012-10-17"
  })

  inline_policy {
    name = join("-", [var.name, "invoke-sfn"])
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [{
        Action   = ["states:StartExecution"]
        Effect   = "Allow"
        Resource = module.sfn.states.arn
      }]
    })
  }
}

# step functions
module "sfn" {
  source      = "../../modules/stepfunctions"
  name        = var.name
  tags        = var.tags
  policy_arns = [aws_iam_policy.invoke-lambda.arn]
  sfn_config = {
    definition = <<EOF
{
  "Comment": "A Hello World example of the Amazon States Language using an AWS Lambda Function",
  "StartAt": "HelloWorld",
  "States": {
    "HelloWorld": {
      "Type": "Task",
      "Resource": "${module.lambda.function.arn}",
      "End": true
    }
  }
}
EOF
  }
}

resource "aws_iam_policy" "invoke-lambda" {
  name = join("-", [var.name, "invoke-lambda"])
  tags = var.tags
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action   = ["lambda:InvokeFunction"]
      Effect   = "Allow"
      Resource = module.lambda.function.arn
    }]
  })
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
    package = "lambda_handler.zip"
    handler = "lambda_handler.lambda_handler"
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
