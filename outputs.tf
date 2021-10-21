output "function" {
  description = "Attributes of lmabda function"
  value       = var.enabled ? aws_lambda_function.lambda.0 : null
}

output "log" {
  description = "Attributes of cloudwatch log group for the lambda function"
  value       = aws_cloudwatch_log_group.lambda
}
