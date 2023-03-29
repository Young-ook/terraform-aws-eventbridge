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

### logs
module "logs" {
  source  = "Young-ook/eventbridge/aws//modules/logs"
  version = "0.0.9"
}

module "logbucket" {
  source        = "Young-ook/sagemaker/aws//modules/s3"
  version       = "0.3.3"
  force_destroy = true
}

### kafka cluster
module "main" {
  source = "../../"
  for_each = { for msk in [
    {
      type = "tc1"
      msk_config = {
        kafka_version   = "2.6.2"
        properties_file = "${path.module}/custom.server.properties"
        monitoring = {
          prometheus_jmx_exporter_enabled  = true
          prometheus_node_exporter_enabled = true
        }
      }
    },
    {
      type = "tc2"
      msk_config = {
        kafka_version = "2.6.2"
        monitoring = {
          prometheus_jmx_exporter_enabled  = false
          prometheus_node_exporter_enabled = true
        }
      }
    },
  ] : msk.type => msk }
  msk_config = lookup(each.value, "msk_config")
  vpc_config = {
    vpc     = module.vpc.vpc.id
    subnets = slice(values(module.vpc.subnets["public"]), 0, 3)
  }
  log_config = {
    cloudwatch_logs = {
      enabled   = true
      log_group = module.logs.log_group.name
    }
    s3 = {
      enabled = true
      bucket  = module.logbucket.bucket.id
    }
  }
}
