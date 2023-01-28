terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }
  }
}

### application/package
data "archive_file" "lambda_zip_file" {
  output_path = join("/", [path.module, "lambda_handler.zip"])
  source_file = join("/", [path.module, "../lambda_function.py"])
  type        = "zip"
}

### application/function
locals {
  functions = [
    {
      name = "layer-only"
      layer = {
        package = data.archive_file.lambda_zip_file.output_path
      }
    },
    {
      name = "with-layer"
      lambda = {
        handler          = "lambda_function.lambda_handler"
        package          = data.archive_file.lambda_zip_file.output_path
        source_code_hash = data.archive_file.lambda_zip_file.output_base64sha256
        publish          = true
      }
      layer = {
        package = data.archive_file.lambda_zip_file.output_path
      }
    }
  ]
}

module "main" {
  for_each = { for fn in local.functions : fn.name => fn }
  source   = "../.."
  lambda   = lookup(each.value, "lambda", {})
  layer    = lookup(each.value, "layer", {})
}

resource "test_assertions" "alias_name" {
  component = "alias_name"

  check "alias_name" {
    description = "lambda alias name"
    condition   = can(regex("^lambda", module.main["with-layer"].alias.name))
  }
}
