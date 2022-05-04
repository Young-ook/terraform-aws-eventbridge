# CodePipeline for CI/CD for AWS Lambda example

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

# pipeline
module "artifact" {
  source        = "Young-ook/sagemaker/aws//modules/s3"
  version       = "0.2.0"
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
    {
      name = "Deploy"
      actions = [{
        name             = "Deploy"
        category         = "Build"
        owner            = "AWS"
        provider         = "CodeBuild"
        version          = "1"
        input_artifacts  = ["source_output"]
        output_artifacts = ["deploy_output"]
        run_order        = 3
        configuration = {
          ProjectName = module.deploy.project.name
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
  source  = "Young-ook/spinnaker/aws//modules/codebuild"
  version = "2.3.1"
  name    = var.name
  tags    = var.tags
  project = {
    environment = {
      image           = "aws/codebuild/standard:4.0"
      privileged_mode = true
      environment_variables = {
        WORKDIR         = "examples/pipeline/lambda"
        PKG             = "lambda_handler.zip"
        ARTIFACT_BUCKET = module.artifact.bucket.id
      }
    }
    source = {
      type      = "GITHUB"
      location  = "https://github.com/Young-ook/terraform-aws-lambda.git"
      buildspec = "examples/pipeline/buildspec/build.yaml"
      version   = "main"
    }
    policy_arns = [module.artifact.policy_arns.write]
  }
}

module "deploy" {
  source  = "Young-ook/spinnaker/aws//modules/codebuild"
  version = "2.3.1"
  name    = var.name
  tags    = var.tags
  project = {
    environment = {
      image = "hashicorp/terraform"
      environment_variables = {
        WORKDIR         = "examples/pipeline/lambda"
        ARTIFACT_BUCKET = module.artifact.bucket.id
      }
    }
    source = {
      type      = "GITHUB"
      location  = "https://github.com/Young-ook/terraform-aws-lambda.git"
      buildspec = "examples/pipeline/buildspec/deploy.yaml"
      version   = "main"
    }
    policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  }
}

# cloudwatch logs
module "logs" {
  source    = "Young-ook/lambda/aws//modules/logs"
  version   = "0.2.1"
  name      = var.name
  log_group = var.log_config
}
