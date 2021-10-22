resource "random_string" "uid" {
  length  = 12
  upper   = false
  lower   = true
  number  = false
  special = false
}

locals {
  namespace      = var.namespace == null || var.namespace == "" ? lookup(local.default_log_config, "namespace") : var.namespace
  name           = var.name == null || var.name == "" ? join("-", ["cw", random_string.uid.result]) : var.name
  log_group_name = join("/", [local.namespace, local.name])
  default-tags = merge(
    { "terraform.io" = "managed" },
  )
}
