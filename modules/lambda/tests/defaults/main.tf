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
module "main" {
  source = "../.."
  lambda = {
    handler          = "lambda_function.lambda_handler"
    package          = data.archive_file.lambda_zip_file.output_path
    source_code_hash = data.archive_file.lambda_zip_file.output_base64sha256
  }
}

### invoke
data "aws_lambda_invocation" "invoke" {
  depends_on    = [module.main]
  function_name = module.main.function.function_name
  input = jsonencode({
    key1 = "value1"
    key2 = "value2"
    key3 = "value3"
  })
}
