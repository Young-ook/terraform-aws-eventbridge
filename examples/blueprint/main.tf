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

### choreography/eventbus
module "default-eventbus" {
  source  = "Young-ook/eventbridge/aws"
  version = "0.0.16"
  name    = "default"
  rules = [
    {
      name                = "scheduled_job"
      schedule_expression = "rate(5 minutes)"
    },
    {
      name          = "pattern_event"
      event_pattern = file("event-pattern-example.json")
    },
  ]
  targets = [
    {
      name = "scheduled-job-lambda"
      rule = "scheduled_job"
      arn  = module.lambda["running"].function.arn
    },
    {
      name = "pattern-event-sfn"
      rule = "pattern_event"
      arn  = module.sfn.states.arn
    },
  ]
}

module "custom-eventbus" {
  source  = "Young-ook/eventbridge/aws"
  version = "0.0.16"
  name    = "custom-eventbus"
  rules = [
    {
      name          = "pattern_event"
      event_pattern = file("event-pattern-example.json")
    },
  ]
  targets = [
    {
      name = "pattern-event-sfn"
      rule = "pattern_event"
      arn  = module.sfn.states.arn
    },
  ]
}

### orchestration/flow
module "sfn" {
  source  = "Young-ook/eventbridge/aws//modules/stepfunctions"
  version = "0.0.16"
  name    = var.name
  tags    = var.tags
  workflow = {
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

### application/package
data "archive_file" "lambda_zip_file" {
  for_each = { for fn in [
    {
      name = "running"
    },
    {
      name = "httpd"
    },
  ] : fn.name => fn }
  output_path = join("/", [path.module, "apps", "build", "${each.key}.zip"])
  source_dir  = join("/", [path.module, "apps", each.key])
  excludes    = ["__init__.py", "*.pyc", "*.yaml"]
  type        = "zip"
}

### application/function
module "lambda" {
  source  = "Young-ook/eventbridge/aws//modules/lambda"
  version = "0.0.15"
  for_each = { for fn in [
    {
      name = "running"
      function = {
        package = data.archive_file.lambda_zip_file["running"].output_path
        handler = "lambda_up_and_running.lambda_handler"
        aliases = [
          {
            name    = "dev"
            version = "$LATEST"
          },
        ]
      }
      tracing     = {}
      vpc         = var.vpc_config
      policy_arns = []
    },
    {
      name = "httpd"
      function = {
        package = data.archive_file.lambda_zip_file["httpd"].output_path
        handler = "lambda_function_over_https.lambda_handler"
      }
      tracing     = {}
      vpc         = var.vpc_config
      policy_arns = [aws_iam_policy.ddb-access.arn]
    },
  ] : fn.name => fn }
  tags        = var.tags
  lambda      = lookup(each.value, "function")
  tracing     = lookup(each.value, "tracing")
  vpc         = lookup(each.value, "vpc")
  policy_arns = lookup(each.value, "policy_arns")
}

### security/policy
resource "aws_iam_policy" "ddb-access" {
  name = "lambda_apigateway_policy"
  path = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

### database/dynamodb
module "dynamodb" {
  source       = "Young-ook/eventbridge/aws//modules/dynamodb"
  version      = "0.0.15"
  name         = "lambda-apigateway"
  tags         = var.tags
  billing_mode = lookup(var.dynamodb_config, "billing_mode", "PROVISIONED")

  attributes = [
    {
      name = "id"
      type = "S"
    },
  ]

  key_schema = {
    hash_key = "id"
  }
}
