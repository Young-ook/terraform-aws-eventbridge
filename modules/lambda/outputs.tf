### output variables

output "alias" {
  description = "Attributes of lmabda function alias"
  value       = local.lambda_enabled ? aws_lambda_alias.alias["enabled"] : null
}

output "function" {
  description = "Attributes of lmabda function"
  value       = local.lambda_enabled ? aws_lambda_function.lambda["enabled"] : null
}

output "layer" {
  description = "Attributes of lmabda layer"
  value       = local.layer_enabled ? aws_lambda_layer_version.layer["enabled"] : null
}

output "logs" {
  description = "Attributes of cloudwatch log group for the lmabda function"
  value       = local.lambda_enabled ? module.logs["enabled"] : null
}
