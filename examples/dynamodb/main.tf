# Using AWS Lambda with API Gateway

terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# dynamodb
module "ddb" {
  source       = "../../modules/dynamodb"
  name         = "lambda-apigateway"
  tags         = var.tags
  billing_mode = lookup(var.dynamodb_config, "billing_mode")

  attributes = [
    {
      name = "id"
      type = "S"
    },
  ]

  key_schema = {
    hash_key = "id"
  }
}

# lambda
data "archive_file" "lambda_zip_file" {
  output_path = join("/", [path.module, "lambda_handler.zip"])
  source_dir  = join("/", [path.module, "app"])
  excludes    = ["__init__.py", "*.pyc"]
  type        = "zip"
}

module "lambda" {
  depends_on = [data.archive_file.lambda_zip_file]
  source     = "Young-ook/lambda/aws"
  version    = "0.2.3"
  name       = var.name
  tags       = var.tags
  lambda = {
    package = "lambda_handler.zip"
    handler = "lambda_function_over_https.handler"
  }
  tracing     = var.tracing_config
  vpc         = var.vpc_config
  policy_arns = [aws_iam_policy.ddb-access.arn]
}

# security/policy
resource "aws_iam_policy" "ddb-access" {
  name = "lambda_apigateway_policy"
  path = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}