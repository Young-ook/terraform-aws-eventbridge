### default variables

## aws partition and region (global, gov, china)
module "aws" {
  source = "Young-ook/spinnaker/aws//modules/aws-partitions"
}

locals {
  policy_arns = var.policy_arns == null ? [] : var.policy_arns
}
