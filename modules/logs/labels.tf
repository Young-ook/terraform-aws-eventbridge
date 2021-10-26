resource "random_string" "uid" {
  length  = 12
  upper   = false
  lower   = true
  number  = false
  special = false
}

locals {
  namespace      = var.log_config == null ? local.default_log_config.namespace : lookup(var.log_config, "namespace", local.default_log_config.namespace)
  name           = var.name == null || var.name == "" ? join("-", ["cw", random_string.uid.result]) : var.name
  log_group_name = join("/", [local.namespace, local.name])
  default-tags = merge(
    { "terraform.io" = "managed" },
  )
}
