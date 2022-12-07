### output variables

output "function" {
  description = "Attributes of lmabda function"
  value       = aws_lambda_function.lambda
}

output "logs" {
  description = "Attributes of cloudwatch log group for the lmabda function"
  value       = module.logs
}
