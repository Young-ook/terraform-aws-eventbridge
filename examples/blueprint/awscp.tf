### pipeline
module "pipeline" {
  source  = "Young-ook/eventbridge/aws//modules/pipeline"
  version = "0.0.7"
  name    = var.name
  tags    = var.tags
  policy_arns = [
    aws_iam_policy.github.arn,
    module.artifact.policy_arns.read,
    module.artifact.policy_arns.write,
  ]
  artifact_config = [{
    location = module.artifact.bucket.id
    type     = "S3"
  }]
  stage_config = [
    {
      name = "Source"
      actions = [{
        name             = "Source"
        category         = "Source"
        owner            = "AWS"
        provider         = "CodeStarSourceConnection"
        version          = "1"
        output_artifacts = ["source_output"]
        run_order        = 1
        configuration = {
          ConnectionArn    = aws_codestarconnections_connection.github.arn
          FullRepositoryId = "Young-ook/terraform-aws-eventbridge"
          BranchName       = "main"
        }
      }]
    },
    {
      name = "Build"
      actions = [{
        name             = "Build"
        category         = "Build"
        owner            = "AWS"
        provider         = "CodeBuild"
        version          = "1"
        input_artifacts  = ["source_output"]
        output_artifacts = ["build_output"]
        run_order        = 2
        configuration = {
          ProjectName = module.build["build"].project.id
        }
      }]
    },
    {
      name = "Deploy"
      actions = [{
        name            = "Deploy"
        category        = "Deploy"
        owner           = "AWS"
        provider        = "CodeDeploy"
        version         = "1"
        input_artifacts = ["build_output"]
        run_order       = 3
        configuration = {
          ApplicationName     = aws_codedeploy_app.lambda-running.name
          DeploymentGroupName = aws_codedeploy_deployment_group.lambda-running.id
        }
      }]
    },
  ]
}

resource "random_pet" "petname" {
  for_each  = toset(["bucket", "github"])
  length    = 3
  separator = "-"
}

### pipeline/artifact
module "artifact" {
  source        = "Young-ook/sagemaker/aws//modules/s3"
  version       = "0.4.0"
  name          = random_pet.petname["bucket"].id
  tags          = var.tags
  force_destroy = true
}

resource "aws_iam_policy" "github" {
  name        = random_pet.petname["github"].id
  description = "Allows to run code build"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect"   = "Allow"
        "Action"   = ["codestar-connections:UseConnection"]
        "Resource" = aws_codestarconnections_connection.github.arn
      },
    ]
  })
}

resource "aws_codestarconnections_connection" "github" {
  name          = random_pet.petname["github"].id
  provider_type = "GitHub"
}

locals {
  projects = [
    {
      name      = "build"
      buildspec = "examples/blueprint/apps/running/buildspec.yaml"
      app_path  = "examples/blueprint/apps/running"
      app_name  = "running"
    },
  ]
}

### pipeline/build
module "build" {
  for_each = { for proj in local.projects : proj.name => proj }
  source   = "Young-ook/spinnaker/aws//modules/codebuild"
  version  = "2.3.6"
  name     = each.key
  tags     = var.tags
  policy_arns = (each.key == "build" ? [
    module.artifact.policy_arns.read,
    module.artifact.policy_arns.write,
    "arn:aws:iam::aws:policy/AWSLambda_FullAccess",
    ] : [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ])
  project = {
    source = {
      type      = "GITHUB"
      location  = "https://github.com/Young-ook/terraform-aws-eventbridge.git"
      buildspec = lookup(each.value, "buildspec")
      version   = "main"
    }
    environment = {
      compute_type    = lookup(each.value, "compute_type", "BUILD_GENERAL1_SMALL")
      type            = lookup(each.value, "type", "LINUX_CONTAINER")
      image           = lookup(each.value, "image", "aws/codebuild/amazonlinux2-x86_64-standard:5.0")
      privileged_mode = true
      environment_variables = {
        ARTIFACT_BUCKET = module.artifact.bucket.id
        APP_PATH        = lookup(each.value, "app_path")
        PKG             = "lambda_handler.zip"
        FUNC            = lookup(each.value, "app_name")
        ALIAS           = "dev"
      }
    }
  }
}

### deploy
resource "aws_codedeploy_app" "lambda-running" {
  name             = join("-", [var.name == null ? "eda" : var.name, "lambda-running"])
  tags             = var.tags
  compute_platform = "Lambda"
}

resource "aws_codedeploy_deployment_group" "lambda-running" {
  app_name               = aws_codedeploy_app.lambda-running.name
  tags                   = var.tags
  deployment_group_name  = join("-", [var.name == null ? "eda" : var.name, "lambda-running"])
  deployment_config_name = "CodeDeployDefault.LambdaAllAtOnce"
  service_role_arn       = aws_iam_role.deploy-lambda.arn

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }
}

resource "aws_iam_role" "deploy-lambda" {
  name = join("-", [var.name == null ? "eda" : var.name, "deploy-lambda"])
  tags = var.tags
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = ["sts:AssumeRole"]
      Effect = "Allow"
      Principal = {
        Service = "codedeploy.amazonaws.com"
      }
    }]
  })
}
