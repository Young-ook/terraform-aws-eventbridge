# AWS Lambda for event-driven architecture example

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

# events
module "event" {
  source     = "../../modules/events"
  name       = join("-", [var.name, "cron"])
  bus_config = null
  rule_config = {
    schedule_expression = "cron(0 20 * * ? *)"
  }
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule = module.event.eventbridge.rule.name
  arn  = module.lambda.function.arn
}

resource "aws_lambda_permission" "lambda" {
  source_arn    = module.event.eventbridge.rule.arn
  function_name = module.lambda.function.id
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
}

# lambda
module "lambda" {
  source = "../../"
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

# pipeline
module "ci" {
  source = "Young-ook/spinnaker/aws//modules/codebuild"
  name   = var.name
  tags   = var.tags
  environment_config = {
    image           = "aws/codebuild/standard:4.0"
    privileged_mode = true
    environment_variables = {
      WORKDIR         = "examples/event-driven"
      PKG             = lookup(var.lambda_config, "package", "lambda_handler.zip")
      ARTIFACT_BUCKET = module.artifact.bucket.id
    }
  }
  source_config = {
    type      = "GITHUB"
    location  = "https://github.com/Young-ook/terraform-aws-lambda.git"
    buildspec = "examples/event-driven/buildspec.yml"
    version   = "main"
  }
  policy_arns = [
    module.artifact.policy_arns["write"],
  ]
}

module "artifact" {
  source        = "Young-ook/spinnaker/aws//modules/s3"
  name          = var.name
  tags          = var.tags
  force_destroy = true
}
