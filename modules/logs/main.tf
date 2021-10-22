## aws cloudwatch logs

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
  retention_in_days = lookup(var.log_config, "retension_days", local.default_log_config["retention_days"])
}
