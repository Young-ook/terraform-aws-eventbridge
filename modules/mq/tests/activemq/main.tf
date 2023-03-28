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
      type = "tc1"
      mq_config = {
        engine_type     = "ActiveMQ" # allowed values: ActiveMQ, RabbitMQ
        properties_file = "${path.module}/activemq.xml"
      }
    },
  ] : mq.type => mq }
  mq = lookup(each.value, "mq_config")
  vpc = {
    vpc     = module.vpc.vpc.id
    subnets = slice(values(module.vpc.subnets["public"]), 0, 1)
  }
}
