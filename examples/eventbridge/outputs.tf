output "event" {
  description = "Attributes of EventBridge"
  value       = module.event
}

output "lambda" {
  description = "Attributes of lmabda function"
  value       = module.lambda.function
}

output "log" {
  description = "Attributes of cloudwatch log group for the lmabda function"
  value       = module.logs
}

output "build" {
  description = "Bash script to start build project"
  value = join(" ", [
    "bash -e",
    module.ci.build,
  ])
}
