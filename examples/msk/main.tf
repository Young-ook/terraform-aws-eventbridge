# AWS Lambda for event-driven architecture example

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

# default vpc
module "vpc" {
  source  = "Young-ook/sagemaker/aws//modules/vpc"
  version = "> 0.0.6"
  name    = var.name
  tags    = var.tags
}

# logs
module "cwlogs" {
  source     = "Young-ook/lambda/aws//modules/logs"
  name       = var.name
  log_config = var.log_config
}

module "logbucket" {
  source        = "Young-ook/sagemaker/aws//modules/s3"
  name          = var.name
  tags          = var.tags
  force_destroy = true
}

# kafka cluster
module "msk" {
  source = "../../modules/msk"
  name   = var.name
  cluster_config = {
    kafka_version = var.msk_config.kafka_version
    monitoring = {
      prometheus_jmx_exporter_enabled  = false
      prometheus_node_exporter_enabled = true
    }
  }
  vpc_config = {
    vpc     = module.vpc.vpc.id
    subnets = slice(values(module.vpc.subnets["public"]), 0, 3)
  }
  log_config = {
    cloudwatch_logs = {
      enabled   = true
      log_group = module.cwlogs.log_group.name
    }
    s3 = {
      enabled = true
      bucket  = module.logbucket.bucket.id
    }
  }
}