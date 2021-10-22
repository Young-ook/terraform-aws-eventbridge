# AWS Lambda in Amazon VPC example

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

# vpc
module "vpc" {
  source     = "Young-ook/spinnaker/aws//modules/spinnaker-aware-aws-vpc"
  name       = var.name
  tags       = var.tags
  azs        = var.azs
  cidr       = var.cidr
  enable_igw = true
  enable_ngw = true
  single_ngw = true
  vpc_endpoint_config = [
    {
      service             = "s3"
      type                = "Interface"
      private_dns_enabled = false
    },
    {
      service             = "lambda"
      type                = "Interface"
      private_dns_enabled = true
    },
    {
      service             = "logs"
      type                = "Interface"
      private_dns_enabled = true
    },

    {
      service             = "sts"
      type                = "Interface"
      private_dns_enabled = true
    },

  ]
}

# security/firewall
resource "aws_security_group" "lambda" {
  name        = var.name
  description = format("security group for vpc endpoint for %s", var.name)
  vpc_id      = module.vpc.vpc.id
  tags        = var.tags

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# lambda
module "lambda" {
  source         = "../../"
  name           = var.name
  tags           = var.tags
  lambda_config  = var.lambda_config
  log_config     = var.log_config
  tracing_config = var.tracing_config
  policies       = var.policies
  vpc_config = {
    subnets         = values(module.vpc.subnets["private"])
    security_groups = [aws_security_group.lambda.id]
  }
}
