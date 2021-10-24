data "aws_region" "current" {}

locals {
  default_lambda_config = {
    package                 = "lambda_handler.zip"
    handler                 = "lambda_handler"
    runtime                 = "python3.8"
    memory                  = 128
    timeout                 = 3
    publish                 = false
    region                  = data.aws_region.current.name
    provisioned_concurrency = -1
    environment_variables   = {}
  }
  default_vpc_config = {}
  default_log_config = {
    name           = format("/aws/lambda/%s", local.name)
    retention_days = 7
  }
  default_tracing_config = {
    mode = "PassThrough"
  }
}
