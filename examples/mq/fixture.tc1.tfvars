aws_region = "ap-northeast-2"
name       = "lambda-eda-activemq"
tags = {
  env    = "dev"
  test   = "tc1"
  engine = "activemq"
}
mq_config = {
  engine_type     = "ActiveMQ" # allowed values: ActiveMQ, RabbitMQ
  properties_file = "activemq.xml"
}
