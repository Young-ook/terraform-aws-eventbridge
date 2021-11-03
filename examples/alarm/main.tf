# AWS CloudWatch Alarm example

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

# cloudwatch alarm
module "alarm" {
  source       = "../../modules/alarm"
  name         = var.name
  description  = var.description
  alarm_config = var.alarm_config
  metric_query = var.metric_query
}
