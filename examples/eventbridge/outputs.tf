output "event" {
  description = "Attributes of EventBridge event buses"
  value = {
    default-bus = module.eventbus
    custom-bus  = module.custom-eventbus
  }
}

output "lambda" {
  description = "Attributes of lmabda function"
  value       = module.lambda.function
}

output "log" {
  description = "Attributes of cloudwatch log group for the lmabda function"
  value       = module.logs
}

output "sfn" {
  description = "Attributes of step functions state machine for the lmabda function"
  value       = module.sfn
}
