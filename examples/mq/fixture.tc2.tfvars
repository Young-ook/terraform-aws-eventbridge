aws_region = "ap-northeast-2"
name       = "lambda-eda-rabbitmq"
tags = {
  env    = "dev"
  test   = "tc1"
  engine = "rabbitmq"
}
mq_config = {
  engine_type = "RabbitMQ" # allowed values: ActiveMQ, RabbitMQ
}
