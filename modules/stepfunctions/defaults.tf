### default variables

### aws paritions
module "aws" {
  source = "Young-ook/spinnaker/aws//modules/aws-partitions"
}

locals {
  workflow = var.workflow == null ? {} : var.workflow
  tracing  = var.tracing == null ? {} : var.tracing
}
