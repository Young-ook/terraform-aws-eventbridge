# default variables

locals {
  policy_arns = var.policy_arns == null ? [] : var.policy_arns
}
