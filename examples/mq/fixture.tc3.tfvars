aws_region = "ap-northeast-2"
name       = "lambda-eda-tc3-rabbitmq"
tags = {
  env    = "dev"
  test   = "tc3"
  engine = "rabbitmq"
}
mq_config = {
  engine_type = "RabbitMQ" # allowed values: ActiveMQ, RabbitMQ
  maintenance = {
    week     = "MONDAY" # Day of the week, e.g., MONDAY, TUESDAY, or WEDNESDAY.
    day      = "02:00"  # Time, in 24-hour format, e.g., 02:00.
    timezone = "CET"    # Time zone in either the Country/City format or the UTC offset format, e.g., CET.
  }
}
