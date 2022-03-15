output "mq" {
  description = "The attributes of message queue broker"
  value       = module.mq
  sensitive   = true
}

output "mq_config" {
  description = "The attributes of message queue broker configuration"
  value       = module.mq.config
}

output "logs" {
  description = "Attributes of cloudwatch log group for the lmabda function"
  value = {
    cwlogs = module.cwlogs
  }
}
