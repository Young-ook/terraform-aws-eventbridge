### aws lambda

### condition
locals {
  lambda_enabled = (var.lambda != null && length(var.lambda) > 0) ? true : false
  layer_enabled  = (var.layer != null && length(var.layer) > 0) ? true : false
  alias_enabled  = (local.lambda_enabled && can(var.lambda.aliases)) ? true : false
}

### computing/environment
resource "aws_lambda_alias" "alias" {
  for_each         = { for a in(local.alias_enabled ? var.lambda.aliases : []) : a.name => a }
  name             = each.key
  function_version = try(each.value.version, "$LATEST")
  function_name    = aws_lambda_function.lambda["enabled"].function_name
}

### computing/function
resource "aws_lambda_function" "lambda" {
  for_each                       = toset(local.lambda_enabled ? ["enabled"] : [])
  function_name                  = local.name
  filename                       = lookup(var.lambda, "package", local.default_lambda_config["package"])
  s3_bucket                      = lookup(var.lambda, "s3_bucket", local.default_bucket_config["s3_bucket"])
  s3_key                         = lookup(var.lambda, "s3_key", local.default_bucket_config["s3_key"])
  s3_object_version              = lookup(var.lambda, "s3_object_version", local.default_bucket_config["s3_object_version"])
  handler                        = lookup(var.lambda, "handler", local.default_lambda_config["handler"])
  runtime                        = lookup(var.lambda, "runtime", local.default_lambda_config["runtime"])
  memory_size                    = lookup(var.lambda, "memory", local.default_lambda_config["memory"])
  timeout                        = lookup(var.lambda, "timeout", local.default_lambda_config["timeout"])
  reserved_concurrent_executions = lookup(var.lambda, "provisioned_concurrency", local.default_lambda_config["provisioned_concurrency"])
  publish                        = lookup(var.lambda, "publish", local.default_lambda_config["publish"])
  source_code_hash               = lookup(var.lambda, "source_code_hash", local.default_lambda_config["source_code_hash"])
  layers                         = local.layer_enabled ? [aws_lambda_layer_version.layer["enabled"].arn] : lookup(var.lambda, "layers", local.default_lambda_config["layers"])
  role                           = aws_iam_role.lambda["enabled"].arn
  tags                           = merge(local.default-tags, var.tags)

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

  dynamic "file_system_config" {
    for_each = var.filesystem != null ? {
      for k, v in [var.filesystem] : k => v if length(var.filesystem) > 0
    } : {}
    content {
      local_mount_path = lookup(file_system_config.value, "local_mount_path", local.default_file_system_config["mount_path"])
      arn              = lookup(file_system_config.value, "arn")
    }
  }
}

### security/policy
resource "aws_iam_role" "lambda" {
  for_each = toset(local.lambda_enabled ? ["enabled"] : [])
  name     = format("%s-lambda", local.name)
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
  for_each   = toset(local.lambda_enabled ? ["enabled"] : [])
  role       = aws_iam_role.lambda["enabled"].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "vpc" {
  for_each   = toset(local.lambda_enabled ? ["enabled"] : [])
  role       = aws_iam_role.lambda["enabled"].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "efs" {
  for_each   = toset(local.lambda_enabled ? ["enabled"] : [])
  role       = aws_iam_role.lambda["enabled"].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientFullAccess"
}

resource "aws_iam_role_policy_attachment" "tracing" {
  for_each   = toset(local.lambda_enabled ? ["enabled"] : [])
  role       = aws_iam_role.lambda["enabled"].name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "logs" {
  for_each   = toset(local.lambda_enabled ? ["enabled"] : [])
  role       = aws_iam_role.lambda["enabled"].name
  policy_arn = module.logs["enabled"].policy_arns["write"]
}

resource "aws_iam_role_policy_attachment" "extra" {
  for_each   = { for key, val in var.policy_arns : key => val if local.lambda_enabled }
  role       = aws_iam_role.lambda["enabled"].name
  policy_arn = each.value
}

### computing/layer
resource "aws_lambda_layer_version" "layer" {
  for_each                 = toset(local.layer_enabled ? ["enabled"] : [])
  layer_name               = local.name
  description              = lookup(var.layer, "desc", local.default_layer_config["desc"])
  license_info             = lookup(var.layer, "license", local.default_layer_config["license"])
  compatible_runtimes      = lookup(var.layer, "runtime", local.default_layer_config["runtime"])
  compatible_architectures = lookup(var.layer, "arch", local.default_layer_config["arch"])
  skip_destroy             = lookup(var.layer, "skip_destroy", false)
  filename                 = lookup(var.layer, "package", local.default_layer_config["package"])
  s3_bucket                = lookup(var.layer, "s3_bucket", local.default_bucket_config["s3_bucket"])
  s3_key                   = lookup(var.layer, "s3_key", local.default_bucket_config["s3_key"])
  s3_object_version        = lookup(var.layer, "s3_object_version", local.default_bucket_config["s3_object_version"])
}

### observability/logs
module "logs" {
  for_each = toset(local.lambda_enabled ? ["enabled"] : [])
  source   = "Young-ook/eventbridge/aws//modules/logs"
  version  = "0.0.6"
  name     = local.name
  log_group = {
    namespace         = lookup(var.logs, "namespace", "/aws/lambda")
    retention_in_days = lookup(var.logs, "retention_days", 7)
  }
}
