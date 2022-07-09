### default values

module "aws" {
  source = "Young-ook/spinnaker/aws//modules/aws-partitions"
}

locals {
  # Compatible architectures are not supported in some regions (ap-northeast-2)
  # That's why we left the default value as null.
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
}
