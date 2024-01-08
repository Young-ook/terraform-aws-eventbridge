### AWS CodePipeline

### security/policy
resource "aws_iam_role" "cp" {
  name = local.name
  tags = merge(local.default-tags, var.tags)
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = format("codepipeline.%s", module.aws.partition.dns_suffix)
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "cb-run" {
  name        = join("-", [local.name, "codebuild-run"])
  description = "Allows to run code build"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" = "Allow"
        "Action" = [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild"
        ]
        "Resource" = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "extra" {
  for_each   = { for k, v in concat([aws_iam_policy.cb-run.arn], local.policy_arns) : k => v }
  policy_arn = each.value
  role       = aws_iam_role.cp.name
}

### workflows
resource "aws_codepipeline" "cp" {
  name     = local.name
  tags     = merge(local.default-tags, var.tags)
  role_arn = aws_iam_role.cp.arn

  dynamic "artifact_store" {
    for_each = { for k, v in var.artifacts : k => v }
    content {
      location = lookup(artifact_store.value, "location")
      type     = lookup(artifact_store.value, "type")
      region   = lookup(artifact_store.value, "region", null)
      dynamic "encryption_key" {
        for_each = { for k, v in lookup(artifact_store.value, "encryption_key", []) : k => v }
        content {
          id   = lookup(encryption_key.value, "id", null)
          type = lookup(encryption_key.value, "type", null)
        }
      }
    }
  }

  dynamic "stage" {
    for_each = { for k, v in var.stages : k => v }
    content {
      name = lookup(stage.value, "name")
      dynamic "action" {
        for_each = { for k, v in lookup(stage.value, "actions", []) : k => v }
        content {
          name             = lookup(action.value, "name")
          category         = lookup(action.value, "category")
          owner            = lookup(action.value, "owner", "AWS")
          provider         = lookup(action.value, "provider", "CloudFormation")
          version          = lookup(action.value, "version")
          input_artifacts  = lookup(action.value, "input_artifacts", [])
          output_artifacts = lookup(action.value, "output_artifacts", [])
          configuration    = lookup(action.value, "configuration", {})
          namespace        = lookup(action.value, "namespace", null)
          run_order        = lookup(action.value, "run_order", null)
          role_arn         = lookup(action.value, "role_arn", null)
          region           = lookup(action.value, "region", null)
        }
      }
    }
  }
}
