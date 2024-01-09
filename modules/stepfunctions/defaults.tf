### default variables

locals {
  workflow = var.workflow == null ? {} : var.workflow
  tracing  = var.tracing == null ? {} : var.tracing
}
