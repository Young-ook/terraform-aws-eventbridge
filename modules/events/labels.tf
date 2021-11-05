resource "random_string" "uid" {
  length  = 12
  upper   = false
  lower   = true
  number  = false
  special = false
}

locals {
  name = var.name == null || var.name == "" ? join("-", ["events", random_string.uid.result]) : var.name
  default-tags = merge(
    { "terraform.io" = "managed" },
  )
}
