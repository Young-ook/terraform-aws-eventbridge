resource "random_string" "uid" {
  length  = 12
  upper   = false
  lower   = true
  number  = false
  special = false
}

locals {
  namespace      = lookup(local.log_group, "namespace", null)
  name           = var.name == null || var.name == "" ? join("-", ["cw", random_string.uid.result]) : var.name
  log_group_name = local.namespace == null ? local.name : join("/", [local.namespace, local.name])
  default-tags = merge(
    { "terraform.io" = "managed" },
  )
}
