## aws cloudwatch logs

locals {
  log_config = var.log_config == null ? local.default_log_config : var.log_config
}

# security/policy
resource "aws_iam_policy" "write" {
  name        = format("%s-logs-write", local.name)
  description = format("Allow to push and write logs to the cloudwatch logs")
  path        = "/"
  policy = jsonencode({
    Statement = [{
      Action = [
        "logs:CreateLogStream",
        "logs:DescribeLogStreams",
        "logs:PutLogEvents",
      ]
      Effect   = "Allow"
      Resource = [aws_cloudwatch_log_group.logs.arn]
    }]
    Version = "2012-10-17"
  })
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = local.log_group_name
  tags              = merge(local.default-tags, var.tags)
  retention_in_days = lookup(local.log_config, "retension_days", local.default_log_config["retention_days"])
}

resource "aws_cloudwatch_log_metric_filter" "filters" {
  for_each       = var.log_metric_filters != null ? { for key, val in var.log_metric_filters : key => val } : {}
  name           = lookup(each.value, "name", each.key)
  pattern        = lookup(each.value, "pattern", null)
  log_group_name = aws_cloudwatch_log_group.logs.name

  metric_transformation {
    name          = lookup(each.value, "name", local.default_log_metric_filter.name)
    namespace     = lookup(each.value, "namespace", local.default_log_metric_filter.namespace)
    value         = lookup(each.value, "value", local.default_log_metric_filter.value)
    default_value = lookup(each.value, "default_value", local.default_log_metric_filter.default_value)
  }
}
