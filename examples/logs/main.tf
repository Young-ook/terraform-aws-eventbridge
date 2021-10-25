# AWS CloudWatch Logs example

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

# cloudwatch logs
module "logs" {
  source     = "../../modules/logs"
  name       = var.name
  namespace  = var.namespace
  log_config = var.log_config
}
