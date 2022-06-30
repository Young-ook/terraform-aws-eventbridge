# AWS Lambda function example

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

# zip arhive
data "archive_file" "lambda_zip_file" {
  output_path = join("/", [path.module, "lambda_handler.zip"])
  source_dir  = join("/", [path.module, "app"])
  excludes    = ["__init__.py", "*.pyc"]
  type        = "zip"
}

# lambda
module "lambda" {
  depends_on = [data.archive_file.lambda_zip_file]
  source     = "Young-ook/lambda/aws"
  name       = var.name
  tags       = var.tags
  lambda     = var.lambda_config
  logs       = var.log_config
  tracing    = var.tracing_config
  vpc        = var.vpc_config
}

# lambda invokation for test
data "aws_lambda_invocation" "invoke" {
  depends_on    = [module.lambda]
  function_name = var.name
  input = jsonencode({
    key1 = "value1"
    key2 = "value2"
    key3 = "value3"
  })
}
