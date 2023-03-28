terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }
  }
}

### network/vpc
module "vpc" {
  source  = "Young-ook/vpc/aws"
  version = "1.0.3"
}

module "main" {
  source = "../../"
  for_each = { for mq in [
    {
      type = "tc2"
      mq_config = {
        engine_type = "RabbitMQ" # allowed values: ActiveMQ, RabbitMQ
      }
    },
    {
      type = "tc3"
      mq_config = {
        engine_type = "RabbitMQ" # allowed values: ActiveMQ, RabbitMQ
        maintenance = {
          week     = "MONDAY" # Day of the week, e.g., MONDAY, TUESDAY, or WEDNESDAY.
          day      = "02:00"  # Time, in 24-hour format, e.g., 02:00.
          timezone = "CET"    # Time zone in either the Country/City format or the UTC offset format, e.g., CET.
        }
      }
    },
  ] : mq.type => mq }
  mq = lookup(each.value, "mq_config")
  vpc = {
    vpc     = module.vpc.vpc.id
    subnets = slice(values(module.vpc.subnets["public"]), 0, 1)
  }
}
