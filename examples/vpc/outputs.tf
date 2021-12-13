output "lambda" {
  description = "Attributes of lmabda function"
  value       = module.lambda.function
}

output "log" {
  description = "Attributes of cloudwatch log group for the lmabda function"
  value       = module.logs
}

output "vpc" {
  description = "Attributes of vpc"
  value       = module.vpc.vpc
}

output "subnets" {
  description = "Subnets of the vpc"
  value       = module.vpc.subnets
}

output "route_tables" {
  description = "Route tables of the vpc"
  value       = module.vpc.route_tables
}
