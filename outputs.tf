output "function" {
  description = "Attributes of lmabda function"
  value       = var.enabled ? aws_lambda_function.lambda.0 : null
}
