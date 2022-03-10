# AWS Lambda in Amazon VPC example

terraform {
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

# vpc
module "vpc" {
  source = "Young-ook/vpc/aws"
  name   = var.name
  tags   = var.tags
  vpc_config = {
    azs         = var.azs
    cidr        = var.cidr
    subnet_type = "private"
  }
  vpce_config = [
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

# zip arhive
data "archive_file" "lambda_zip_file" {
  output_path = join("/", [path.module, "lambda_handler.zip"])
  source_dir  = join("/", [path.module, "app"])
  excludes    = ["__init__.py", "*.pyc"]
  type        = "zip"
}

# lambda
module "lambda" {
  source  = "Young-ook/lambda/aws"
  name    = var.name
  tags    = var.tags
  lambda  = var.lambda_config
  tracing = var.tracing_config
  vpc = {
    subnets         = values(module.vpc.subnets["private"])
    security_groups = [aws_security_group.lambda.id]
  }
  policy_arns = [module.logs.policy_arns["write"]]
}

# cloudwatch logs
module "logs" {
  source     = "Young-ook/lambda/aws//modules/logs"
  name       = var.name
  log_config = var.log_config
}
