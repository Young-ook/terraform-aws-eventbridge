# AWS CloudWatch Logs example

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

# cloudwatch logs
module "logs" {
  source             = "../../modules/logs"
  name               = var.name
  log_config         = var.log_config
  log_metric_filters = var.log_metric_filters
}
