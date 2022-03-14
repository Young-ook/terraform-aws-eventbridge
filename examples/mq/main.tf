# AWS Lambda for event-driven architecture example

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

# default vpc
module "vpc" {
  source  = "Young-ook/vpc/aws"
  version = "> 1.0"
  name    = var.name
  tags    = var.tags
}

# logs
module "cwlogs" {
  source    = "Young-ook/lambda/aws//modules/logs"
  version   = ">= 0.1.3"
  name      = var.name
  log_group = var.cwlog_config
}

# message queue
module "mq" {
  source = "../../modules/mq"
  name   = var.name
  mq     = var.mq_config
  vpc = {
    vpc     = module.vpc.vpc.id
    subnets = slice(values(module.vpc.subnets["public"]), 0, 1)
  }
}
