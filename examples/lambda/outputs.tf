output "lambda" {
  description = "Attributes of lmabda function"
  value       = module.lambda.lambda
}

output "log" {
  description = "Attributes of cloudwatch log group for the lmabda function"
  value       = module.lambda.log
}
