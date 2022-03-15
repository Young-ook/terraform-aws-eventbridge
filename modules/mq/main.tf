# managed message queue broker (Amazon MQ)

## parameters
locals {
  compatibility   = lookup(var.mq, "engine_type", "ActiveMQ")
  default_cluster = (local.compatibility == "ActiveMQ" ? local.default_activemq_cluster : local.default_rabbitmq_cluster)
  config          = lookup(var.mq, "properties_file", null)
  vpc             = lookup(var.vpc, "vpc", local.default_vpc_config.vpc)
  subnets         = lookup(var.vpc, "subnets", local.default_vpc_config.subnets)
  security_groups = lookup(var.vpc, "security_groups", local.default_vpc_config.security_groups)
  users           = lookup(var.mq, "users", local.default_cluster.users)
}

# aws partition and region (global, gov, china)
module "aws" {
  source = "Young-ook/spinnaker/aws//modules/aws-partitions"
}

# security/secret
module "vault" {
  source  = "Young-ook/passport/aws//modules/aws-secrets"
  version = "0.0.4"
  name    = join("-", [local.default_admin.username, local.name])
  secret  = random_password.password.result
}

# security/password
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "^"
}

## cluster
resource "aws_mq_configuration" "mq" {
  for_each       = toset(local.compatibility == "ActiveMQ" && local.config != null ? ["activemq"] : [])
  name           = local.name
  tags           = merge(local.default-tags, var.tags)
  engine_type    = lookup(var.mq, "engine_type", local.default_cluster.engine_type)
  engine_version = lookup(var.mq, "engine_version", local.default_cluster.engine_version)
  data           = file(lookup(var.mq, "properties_file"))
}

resource "aws_mq_broker" "mq" {
  broker_name                = local.name
  tags                       = merge(local.default-tags, var.tags)
  deployment_mode            = lookup(var.mq, "deployment_mode", local.default_cluster.deployment_mode)
  engine_type                = lookup(var.mq, "engine_type", local.default_cluster.engine_type)
  engine_version             = lookup(var.mq, "engine_version", local.default_cluster.engine_version)
  host_instance_type         = lookup(var.mq, "host_instance_type", local.default_cluster.host_instance_type)
  storage_type               = lookup(var.mq, "storage_type", local.default_cluster.storage_type)
  auto_minor_version_upgrade = true
  apply_immediately          = false
  publicly_accessible        = true
  subnet_ids                 = local.subnets
  security_groups            = local.security_groups

  dynamic "configuration" {
    for_each = toset(local.compatibility == "ActiveMQ" && local.config != null ? [aws_mq_configuration.mq["activemq"]] : [])
    content {
      id       = configuration.value.id
      revision = configuration.value.latest_revision
    }
  }

  dynamic "logs" {
    for_each = { for k, v in lookup(var.mq, "logs", local.default_cluster.logs) : k => v }
    content {
      audit   = logs.value.audit_log_enabled
      general = logs.value.general_log_enabled
    }
  }

  dynamic "encryption_options" {
    for_each = lookup(var.mq, "encryption_enabled", false) ? ["enabled"] : []
    content {
      kms_key_id        = lookup(var.mq, "kms_mq_key_arn")
      use_aws_owned_key = lookup(var.mq, "use_aws_owned_key")
    }
  }

  /*
  maintenance_window_start_time {
    day_of_week = var.maintenance_day_of_week
    time_of_day = var.maintenance_time_of_day
    time_zone   = var.maintenance_time_zone
  }
*/

  dynamic "user" {
    for_each = { for user in(local.default_cluster.admin_enabled ? [local.default_admin] : []) : user.username => user }
    content {
      username       = lookup(user.value, "username", local.default_admin.username)
      password       = lookup(user.value, "password", random_password.password.result)
      groups         = lookup(user.value, "groups", local.default_admin.groups)
      console_access = lookup(user.value, "console_access", local.default_admin.console_access)
    }
  }

  dynamic "user" {
    for_each = { for user in local.users : user.username => user }
    content {
      username       = lookup(user.value, "username")
      password       = lookup(user.value, "password")
      groups         = lookup(user.value, "groups", null)
      console_access = lookup(user.value, "console_access", false)
    }
  }
}
