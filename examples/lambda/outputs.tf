output "lambda" {
  description = "Attributes of lmabda function"
  value       = module.lambda.lambda
}

output "log" {
  description = "Attributes of cloudwatch log group for the lmabda function"
  value       = module.lambda.log
}

output "result" {
  description = "Lambda function invocation result"
  value       = jsonencode(data.aws_lambda_invocation.invoke.result)
}
