locals {
  name = var.name
  default-tags = merge(
    { "terraform.io" = "managed" },
  )
}
