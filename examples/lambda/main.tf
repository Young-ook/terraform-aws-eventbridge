# ARM64 node groups example

terraform {
  required_version = "0.13.5"
}

provider "aws" {
  region              = var.aws_region
  allowed_account_ids = [var.aws_account_id]
}

# lambda
module "lambda" {

  #  source              = "Young-ook/lambda/aws"

  source         = "../../"
  name           = var.name
  tags           = var.tags
  lambda_config  = var.lambda_config
  log_config     = var.log_config
  tracing_config = var.tracing_config
  vpc_config     = var.vpc_config
}
