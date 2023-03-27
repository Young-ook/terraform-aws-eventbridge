terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }
  }
}

resource "random_pet" "petname" {
  for_each  = toset(["sg", ])
  length    = 3
  separator = "-"
}

### network/vpc
module "vpc" {
  source  = "Young-ook/vpc/aws"
  version = "1.0.3"
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

### security/firewall
resource "aws_security_group" "lambda" {
  name        = random_pet.petname["sg"].id
  description = format("security group for lambda function")
  vpc_id      = module.vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

### application/package
data "archive_file" "lambda_zip_file" {
  output_path = join("/", [path.module, "lambda_handler.zip"])
  source_file = join("/", [path.module, "../lambda_function.py"])
  type        = "zip"
}

### application/function
module "main" {
  source = "../.."
  lambda = {
    handler          = "lambda_function.lambda_handler"
    package          = data.archive_file.lambda_zip_file.output_path
    source_code_hash = data.archive_file.lambda_zip_file.output_base64sha256
  }
  vpc = {
    subnets         = values(module.vpc.subnets["public"])
    security_groups = [aws_security_group.lambda.id]
  }
}

### invoke
data "aws_lambda_invocation" "invoke" {
  depends_on    = [module.main]
  function_name = module.main.function.function_name
  input = jsonencode({
    key1 = "value1"
    key2 = "value2"
    key3 = "value3"
  })
}
