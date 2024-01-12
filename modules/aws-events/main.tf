### bus
module "event" {
  source  = "Young-ook/eventbridge/aws"
  version = "0.0.16"
  tags    = var.tags
  rules   = var.rules
  targets = [for k, v in var.rules : {
    name = join("-", [v.name, "target"])
    rule = v.name,
    arn  = module.lambda.function.arn
  }]
}

### handler
module "lambda" {
  source      = "Young-ook/eventbridge/aws//modules/lambda"
  version     = "0.0.16"
  name        = var.name
  tags        = var.tags
  lambda      = lookup(var.lambda, "function")
  logs        = lookup(var.lambda, "logs", {})
  tracing     = lookup(var.lambda, "tracing", {})
  policy_arns = lookup(var.lambda, "policy", [])
  vpc         = var.vpc
}
