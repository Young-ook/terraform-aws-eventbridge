output "msk" {
  description = "Attributes of Apache Kafka cluster"
  value       = module.msk
}

output "logs" {
  description = "Attributes of cloudwatch log group for the lmabda function"
  value = {
    cwlogs = module.cwlogs
    s3     = module.logbucket
  }
}
