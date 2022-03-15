output "mq" {
  description = "The attributes of generated message queue broker"
  value       = aws_mq_broker.mq
}

output "config" {
  description = "The attributes of message queue broker configuration"
  value       = aws_mq_configuration.mq
}

