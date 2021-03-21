### function
resource "aws_lambda_function" "lambda" {
  count                          = var.enabled ? 1 : 0
  function_name                  = local.name
  filename                       = lookup(var.lambda_config, "package", local.default_lambda_config["package"])
  handler                        = lookup(var.lambda_config, "handler", local.default_lambda_config["handler"])
  runtime                        = lookup(var.lambda_config, "runtime", local.default_lambda_config["runtime"])
  memory_size                    = lookup(var.lambda_config, "memory", local.default_lambda_config["memory"])
  timeout                        = lookup(var.lambda_config, "timeout", local.default_lambda_config["timeout"])
  reserved_concurrent_executions = lookup(var.lambda_config, "provisioned_concurrency", local.default_lambda_config["provisioned_concurrency"])
  source_code_hash               = filebase64sha256(lookup(var.lambda_config, "package", local.default_lambda_config["package"]))
  publish                        = lookup(var.lambda_config, "publish", local.default_lambda_config["publish"])
  role                           = aws_iam_role.lambda.0.arn
  tags                           = merge(local.default-tags, var.tags)

  lifecycle {
    ignore_changes = [filename]
  }

  dynamic "environment" {
    for_each = local.default_lambda_config["environment_variables"]
    content {
      variables = environment
    }
  }

  dynamic "tracing_config" {
    for_each = var.tracing_config != null ? {
      for key, val in [var.tracing_config] : key => val
    } : {}
    content {
      mode = lookup(tracing_config.value, "mode", local.default_tracing_config["mode"])
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? {
      for key, val in [var.vpc_config] : key => val
    } : {}
    content {
      subnet_ids         = lookup(vpc_config.value, "subnets", null)
      security_group_ids = lookup(vpc_config.value, "security_groups", null)
    }
  }
}

data "aws_partition" "current" {}

### security/policy
resource "aws_iam_role" "lambda" {
  count = var.enabled ? 1 : 0
  name  = format("%s-lambda", local.name)
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = format("lambda.%s", data.aws_partition.current.dns_suffix)
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "execution" {
  count      = var.enabled ? 1 : 0
  role       = aws_iam_role.lambda.0.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "vpc-access" {
  count      = var.enabled ? 1 : 0
  role       = aws_iam_role.lambda.0.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "tracing" {
  count      = var.enabled ? 1 : 0
  role       = aws_iam_role.lambda.0.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

resource "aws_cloudwatch_log_group" "lambda" {
  for_each = var.enabled && var.log_config != null ? {
    for key, val in [var.log_config] : key => val
  } : {}
  name              = local.default_log_config["name"]
  retention_in_days = lookup(var.log_config, "retension_days", local.default_log_config["retention_days"])
}
