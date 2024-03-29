### step functions state machine

### security/policy
resource "aws_iam_role" "sfn" {
  name = format("%s-sfn", local.name)
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = format("states.%s", module.aws.partition.dns_suffix)
      }
    }]
  })

  inline_policy {
    name = join("-", [local.name, "invoke-targets"])
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Action = [
          "lambda:InvokeFunction",
        ]
        Effect   = "Allow"
        Resource = ["*"]
      }]
    })
  }
}

resource "aws_iam_role_policy_attachment" "tracing" {
  role       = aws_iam_role.sfn.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "extra" {
  for_each   = { for key, val in var.policy_arns : key => val }
  role       = aws_iam_role.sfn.name
  policy_arn = each.value
}

### state machine
resource "aws_sfn_state_machine" "sfn" {
  name       = local.name
  role_arn   = aws_iam_role.sfn.arn
  definition = lookup(var.workflow, "definition")
}
