output "lambda" {
  description = "Attributes of lmabda function"
  value       = aws_lambda_function.lambda
}

output "log" {
  description = "Attributes of cloudwatch log group for the lambda function"
  value       = aws_cloudwatch_log_group.lambda
}
