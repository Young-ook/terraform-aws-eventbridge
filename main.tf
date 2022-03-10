### serverless aws lambda

module "aws" {
  source = "Young-ook/spinnaker/aws//modules/aws-partitions"
}

resource "aws_lambda_function" "lambda" {
  function_name                  = local.name
  filename                       = lookup(var.lambda, "package", null)
  s3_bucket                      = lookup(var.lambda, "s3_bucket", null)
  s3_key                         = lookup(var.lambda, "s3_key", null)
  s3_object_version              = lookup(var.lambda, "s3_object_version", null)
  handler                        = lookup(var.lambda, "handler", local.default_lambda_config["handler"])
  runtime                        = lookup(var.lambda, "runtime", local.default_lambda_config["runtime"])
  memory_size                    = lookup(var.lambda, "memory", local.default_lambda_config["memory"])
  timeout                        = lookup(var.lambda, "timeout", local.default_lambda_config["timeout"])
  reserved_concurrent_executions = lookup(var.lambda, "provisioned_concurrency", local.default_lambda_config["provisioned_concurrency"])
  publish                        = lookup(var.lambda, "publish", local.default_lambda_config["publish"])
  role                           = aws_iam_role.lambda.arn
  tags                           = merge(local.default-tags, var.tags)

  lifecycle {
    ignore_changes = [filename]
  }

  dynamic "environment" {
    for_each = lookup(var.lambda, "environment_variables", null) != null ? {
      for k, v in [lookup(var.lambda, "environment_variables")] : k => v
    } : {}
    content {
      variables = lookup(var.lambda, "environment_variables")
    }
  }

  dynamic "tracing_config" {
    for_each = var.tracing != null ? {
      for k, v in [var.tracing] : k => v
    } : {}
    content {
      mode = lookup(tracing_config.value, "mode", local.default_tracing_config["mode"])
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc != null ? {
      for k, v in [var.vpc] : k => v if length(var.vpc) > 0
    } : {}
    content {
      subnet_ids         = lookup(vpc_config.value, "subnets")
      security_group_ids = lookup(vpc_config.value, "security_groups")
    }
  }
}

data "aws_partition" "current" {}

### security/policy
resource "aws_iam_role" "lambda" {
  name = format("%s-lambda", local.name)
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = format("lambda.%s", module.aws.partition.dns_suffix)
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "execution" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "vpc-access" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "tracing" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "extra" {
  for_each   = { for key, val in var.policy_arns : key => val }
  role       = aws_iam_role.lambda.name
  policy_arn = each.value
}
