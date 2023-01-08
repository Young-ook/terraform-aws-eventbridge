### output variables

output "alias" {
  description = "Attributes of lmabda function alias"
  value       = aws_lambda_alias.alias
}

output "function" {
  description = "Attributes of lmabda function"
  value       = aws_lambda_function.lambda
}

output "logs" {
  description = "Attributes of cloudwatch log group for the lmabda function"
  value       = module.logs
}
