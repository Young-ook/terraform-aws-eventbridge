### default values

module "aws" {
  source = "Young-ook/spinnaker/aws//modules/aws-partitions"
}

locals {
  default_lambda_config = {
    package                 = null
    handler                 = "lambda_handler"
    runtime                 = "python3.8"
    memory                  = 128
    timeout                 = 3
    publish                 = false
    layers                  = []
    region                  = module.aws.region.name
    provisioned_concurrency = -1
    source_code_hash        = null
    environment_variables   = {}
  }
  default_layer_config = {
    package = null
    desc    = null
    license = null
    runtime = ["python3.8"]
    arch    = null
  }
  default_bucket_config = {
    s3_bucket         = null
    s3_key            = null
    s3_object_version = null
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
