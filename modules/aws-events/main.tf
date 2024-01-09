### bus
module "event" {
  source  = "Young-ook/eventbridge/aws"
  version = "0.0.6"
  tags    = var.tags
  rules   = var.rules
}

resource "aws_cloudwatch_event_target" "lambda" {
  for_each = { for r in var.rules : r.name => r }
  rule     = module.event.rules[each.key].name
  arn      = module.lambda.function.arn
}

resource "aws_lambda_permission" "lambda" {
  for_each      = { for r in var.rules : r.name => r }
  source_arn    = module.event.rules[each.key].arn
  function_name = module.lambda.function.id
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
}

### handler
module "lambda" {
  source      = "Young-ook/eventbridge/aws//modules/lambda"
  version     = "0.0.12"
  name        = var.name
  tags        = var.tags
  lambda      = lookup(var.lambda, "function")
  logs        = lookup(var.lambda, "logs", {})
  tracing     = lookup(var.lambda, "tracing", {})
  policy_arns = lookup(var.lambda, "policy", [])
  vpc         = var.vpc
}
