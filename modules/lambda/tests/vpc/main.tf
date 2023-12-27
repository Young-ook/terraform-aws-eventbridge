terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }
  }
}

### network/vpc
module "vpc" {
  source  = "Young-ook/vpc/aws"
  version = "1.0.6"
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

### filesystem
module "efs" {
  source  = "Young-ook/sagemaker/aws//modules/efs"
  version = "0.4.6"
  vpc     = module.vpc.vpc.id
  subnets = values(module.vpc.subnets["public"])
  filesystem = {
    encrypted = false
  }
  access_points = [
    {
      uid         = "1001"
      gid         = "1001"
      permissions = "750"
      path        = "/export/lambda"
    }
  ]
}

resource "time_sleep" "wait_efs" {
  depends_on      = [module.efs]
  create_duration = "5s"
}

### application/package
data "archive_file" "lambda_zip_file" {
  depends_on  = [time_sleep.wait_efs]
  output_path = join("/", [path.module, "lambda_handler.zip"])
  source_file = join("/", [path.module, "../lambda_function.py"])
  type        = "zip"
}

### application/function
module "main" {
  depends_on = [time_sleep.wait_efs]
  source     = "../.."
  lambda = {
    handler          = "lambda_function.lambda_handler"
    package          = data.archive_file.lambda_zip_file.output_path
    source_code_hash = data.archive_file.lambda_zip_file.output_base64sha256
  }
  vpc = {
    subnets         = values(module.vpc.subnets["public"])
    security_groups = [module.efs.security_group.id]
  }
  filesystem = {
    local_mount_path = "/mnt/data"
    arn              = module.efs.ap.0.arn
  }
}

resource "time_sleep" "wait_lambda" {
  depends_on      = [module.main]
  create_duration = "5s"
}

### invoke
data "aws_lambda_invocation" "invoke" {
  depends_on    = [time_sleep.wait_lambda]
  function_name = module.main.function.function_name
  input = jsonencode({
    key1 = "value1"
    key2 = "value2"
    key3 = "value3"
  })
}
