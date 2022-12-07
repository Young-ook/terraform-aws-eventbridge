### serverless aws lambda

### computing/layer
resource "aws_lambda_layer_version" "layer" {
  layer_name               = local.name
  description              = lookup(var.layer, "desc", local.default_layer_config["desc"])
  license_info             = lookup(var.layer, "license", local.default_layer_config["license"])
  compatible_runtimes      = lookup(var.layer, "runtime", local.default_layer_config["runtime"])
  compatible_architectures = lookup(var.layer, "arch", local.default_layer_config["arch"])
  skip_destroy             = lookup(var.layer, "skip_destroy", false)
  filename                 = lookup(var.layer, "package", local.default_layer_config["package"])
  s3_bucket                = lookup(var.layer, "s3_bucket", local.default_bucket_config["s3_bucket"])
  s3_key                   = lookup(var.layer, "s3_key", local.default_bucket_config["s3_key"])
  s3_object_version        = lookup(var.layer, "s3_object_version", local.default_bucket_config["s3_object_version"])
}
