# Event-Driven Architecture on AWS

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

# EventBridge rules
#
# This is a example of scheduling expression, cron(0 20 * * ? *) or rate(5 minutes).
# At least one of schedule_expression or event_pattern is required for event rule config.
# It can only be used on the default event bus. For more information, refer to the
# AWS documentation Schedule Expressions for Rules:
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html
locals {
  event_rules = [
    {
      name                = "scheduled_job"
      schedule_expression = "rate(5 minutes)"
    },
    {
      name          = "pattern_event"
      event_pattern = file("event-pattern-example.json")
    },
  ]
}

### choreography/eventbus
module "default-eventbus" {
  source  = "Young-ook/eventbridge/aws"
  version = "0.0.8"
  name    = "default"
  rules   = local.event_rules
}

module "custom-eventbus" {
  source  = "Young-ook/eventbridge/aws"
  version = "0.0.8"
  name    = "custom-eventbus"
  rules   = [element(local.event_rules, 1)]
}

### choreography/route
resource "aws_cloudwatch_event_target" "sfn" {
  for_each = { for e in local.event_rules : e.name => e }
  rule     = module.default-eventbus.rules[each.key].name
  arn      = module.sfn.states.arn
  role_arn = aws_iam_role.invoke-sfn.arn
}

module "aws" {
  source = "Young-ook/spinnaker/aws//modules/aws-partitions"
}

### security/policy
resource "aws_iam_role" "invoke-sfn" {
  name = join("-", [var.name == null ? "eda" : var.name, "invoke-sfn"])
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
    name = join("-", [var.name == null ? "eda" : var.name, "invoke-sfn"])
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

### orchestration/flow
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
      "Resource": "${module.lambda["running"].function.arn}",
      "End": true
    }
  }
}
EOF
  }
}

resource "aws_iam_policy" "invoke-lambda" {
  name = join("-", [var.name == null ? "eda" : var.name, "invoke-lambda"])
  tags = var.tags
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action   = ["lambda:InvokeFunction"]
      Effect   = "Allow"
      Resource = module.lambda["running"].function.arn
    }]
  })
}

### application/package
data "archive_file" "lambda_zip_file" {
  for_each = { for fn in [
    {
      name = "running"
    },
  ] : fn.name => fn }
  output_path = join("/", [path.module, "apps", "build", "${each.key}.zip"])
  source_dir  = join("/", [path.module, "apps", each.key])
  excludes    = ["__init__.py", "*.pyc"]
  type        = "zip"
}

### application/function
module "lambda" {
  source  = "Young-ook/eventbridge/aws//modules/lambda"
  version = "0.0.8"
  for_each = { for fn in [
    {
      name = "running"
      function = {
        package = data.archive_file.lambda_zip_file["running"].output_path
        handler = "running.lambda_handler"
      }
      tracing = {}
      vpc     = var.vpc_config
    },
  ] : fn.name => fn }
  name    = each.key
  tags    = var.tags
  lambda  = lookup(each.value, "function")
  tracing = lookup(each.value, "tracing")
  vpc     = lookup(each.value, "vpc")
}
