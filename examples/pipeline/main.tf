# AWS Lambda for event-driven architecture example

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

# pipeline
module "artifact" {
  source        = "Young-ook/spinnaker/aws//modules/s3"
  name          = var.name
  tags          = var.tags
  force_destroy = true
}

resource "aws_iam_policy" "github" {
  name        = join("-", [var.name, "gh-conn"])
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
  name          = join("-", [var.name, "gh-conn"])
  provider_type = "GitHub"
}

module "pipeline" {
  source      = "../../modules/pipeline"
  name        = var.name
  tags        = var.tags
  policy_arns = var.policy_arns
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
          FullRepositoryId = "Young-ook/terraform-aws-lambda"
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
          ProjectName = module.build.project.name
        }
      }]
    },
  ]
  artifact_config = [{
    location = module.artifact.bucket.id
    type     = "S3"
  }]
}

module "build" {
  source = "Young-ook/spinnaker/aws//modules/codebuild"
  name   = var.name
  tags   = var.tags
  environment_config = {
    image           = "aws/codebuild/standard:4.0"
    privileged_mode = true
    environment_variables = {
      WORKDIR         = "examples/pipeline"
      PKG             = "lambda_handler.zip"
      ARTIFACT_BUCKET = module.artifact.bucket.id
    }
  }
  source_config = {
    type      = "GITHUB"
    location  = "https://github.com/Young-ook/terraform-aws-lambda.git"
    buildspec = "examples/event-driven/buildspec.yml"
    version   = "main"
  }
  policy_arns = [
    module.artifact.policy_arns["write"],
  ]
}

module "deploy" {
  source = "Young-ook/spinnaker/aws//modules/codebuild"
  name   = var.name
  tags   = var.tags
  environment_config = {
    image           = "aws/codebuild/standard:4.0"
    privileged_mode = true
    environment_variables = {
      WORKDIR         = "examples/pipeline"
      PKG             = "lambda_handler.zip"
      ARTIFACT_BUCKET = module.artifact.bucket.id
    }
  }
  source_config = {
    type      = "GITHUB"
    location  = "https://github.com/Young-ook/terraform-aws-lambda.git"
    buildspec = "examples/event-driven/buildspec.yml"
    version   = "main"
  }
  policy_arns = [
    module.artifact.policy_arns["write"],
  ]
}

# cloudwatch logs
module "logs" {
  source     = "Young-ook/lambda/aws//modules/logs"
  name       = var.name
  log_config = var.log_config
}

