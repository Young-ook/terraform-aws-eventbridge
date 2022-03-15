# default variables

locals {
  default_vpc_config = {
    vpc             = null
    subnets         = null
    security_groups = []
  }
  default_admin = {
    username       = "admin"
    groups         = ["admin"]
    console_access = true
  }
  default_activemq_cluster = {
    engine_type                = "ActiveMQ"
    engine_version             = "5.16.3"
    deployment_mode            = "SINGLE_INSTANCE" # SINGLE_INSTANCE, ACTIVE_STANDBY_MULTI_AZ, CLUSTER_MULTI_AZ
    host_instance_type         = "mq.m5.large"
    storage_type               = "efs"
    user                       = "yourid"
    auto_minor_version_upgrade = true
    apply_immediately          = false
    publicly_accessible        = false
    admin_enabled              = true
    users                      = []
    logs = [
      {
        audit_log_enabled   = false
        general_log_enabled = false
      }
    ]
  }
  default_rabbitmq_cluster = {
    engine_type                = "RabbitMQ"
    engine_version             = "3.8.26"
    deployment_mode            = "SINGLE_INSTANCE" # SINGLE_INSTANCE, CLUSTER_MULTI_AZ
    host_instance_type         = "mq.m5.large"
    storage_type               = "ebs"
    user                       = "yourid"
    auto_minor_version_upgrade = true
    apply_immediately          = false
    publicly_accessible        = false
    admin_enabled              = true
    users                      = []
    logs = [
      {
        audit_log_enabled   = null
        general_log_enabled = false
      }
    ]
  }
}
