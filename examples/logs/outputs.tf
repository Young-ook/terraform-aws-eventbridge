output "log" {
  description = "Attributes of cloudwatch log group"
  value       = module.logs
}

output "alarm" {
  description = "CloudWatch alarm by log filtering"
  value       = module.alarm
}
