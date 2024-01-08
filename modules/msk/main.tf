# managed streaming for apache kafka

## parameters
locals {
  vpc             = lookup(var.vpc, "vpc", local.default_vpc_config.vpc)
  subnets         = lookup(var.vpc, "subnets", local.default_vpc_config.subnets)
  security_groups = lookup(var.vpc, "security_groups", local.default_vpc_config.security_groups)
  kafka_version   = lookup(var.msk, "kafka_version", local.default_msk_config.kafka_version)
  instance_count  = lookup(var.msk, "instance_count", local.default_msk_config.instance_count)
  instance_type   = lookup(var.msk, "instance_type", local.default_msk_config.instance_type)
  disk_size       = lookup(var.msk, "disk_size", local.default_msk_config.disk_size)
  scaling_policy  = lookup(var.msk, "scaling_policy", local.default_msk_config.scaling_policy)
  monitoring      = lookup(var.msk, "monitoring", local.default_msk_config.monitoring)
  properties_file = lookup(var.msk, "properties_file", local.default_msk_config.properties_file)
}

## cluster
resource "aws_msk_configuration" "kafka" {
  name              = local.name
  kafka_versions    = [local.kafka_version]
  server_properties = file(local.properties_file)
}

resource "aws_msk_cluster" "kafka" {
  cluster_name           = local.name
  tags                   = merge(local.default-tags, var.tags)
  kafka_version          = local.kafka_version
  number_of_broker_nodes = local.instance_count

  configuration_info {
    arn      = aws_msk_configuration.kafka.arn
    revision = aws_msk_configuration.kafka.latest_revision
  }

  broker_node_group_info {
    instance_type   = local.instance_type
    client_subnets  = local.subnets
    security_groups = local.security_groups == null || local.security_groups == [] ? [aws_security_group.kafka.id] : local.security_groups
    storage_info {
      ebs_storage_info {
        volume_size = local.disk_size
      }
    }
  }
  /* 
  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.cmk.arn
  }
 */
  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = lookup(local.monitoring, "prometheus_jmx_exporter_enabled", local.monitoring.prometheus_jmx_exporter_enabled)
      }
      node_exporter {
        enabled_in_broker = lookup(local.monitoring, "prometheus_node_exporter_enabled", local.monitoring.prometheus_node_exporter_enabled)
      }
    }
  }

  dynamic "logging_info" {
    for_each = toset([var.log])
    content {
      broker_logs {
        dynamic "cloudwatch_logs" {
          for_each = toset([lookup(logging_info.value, "cloudwatch_logs", local.default_log_config.cloudwatch_logs)])
          content {
            enabled   = lookup(cloudwatch_logs.value, "enabled", local.default_log_config.cloudwatch_logs.enabled)
            log_group = lookup(cloudwatch_logs.value, "log_group", local.default_log_config.cloudwatch_logs.log_group)
          }
        }

        dynamic "firehose" {
          for_each = toset([lookup(logging_info.value, "firehose", local.default_log_config.firehose)])
          content {
            enabled         = lookup(firehose.value, "enabled", local.default_log_config.firehose.enabled)
            delivery_stream = lookup(firehose.value, "delivery_stream", local.default_log_config.firehose.delivery_stream)
          }
        }

        dynamic "s3" {
          for_each = toset([lookup(logging_info.value, "s3", local.default_log_config.s3)])
          content {
            enabled = lookup(s3.value, "enabled", local.default_log_config.s3.enabled)
            bucket  = lookup(s3.value, "bucket", local.default_log_config.s3.bucket)
            prefix  = lookup(s3.value, "prefix", local.default_log_config.s3.prefix)
          }
        }
      }
    }
  }
}

resource "aws_appautoscaling_target" "kafka" {
  max_capacity       = lookup(local.scaling_policy, "max_disk_size", local.scaling_policy.max_disk_size)
  min_capacity       = 1
  resource_id        = aws_msk_cluster.kafka.arn
  scalable_dimension = "kafka:broker-storage:VolumeSize"
  service_namespace  = "kafka"
}

resource "aws_appautoscaling_policy" "kafka" {
  name               = join("-", [local.name, "broker-scaling"])
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_msk_cluster.kafka.arn
  scalable_dimension = join("", aws_appautoscaling_target.kafka.*.scalable_dimension)
  service_namespace  = join("", aws_appautoscaling_target.kafka.*.service_namespace)

  target_tracking_scaling_policy_configuration {
    target_value     = lookup(local.scaling_policy, "tracking_target", local.scaling_policy.tracking_target)
    disable_scale_in = lookup(local.scaling_policy, "disable_scale_in", local.scaling_policy.disable_scale_in)
    predefined_metric_specification {
      predefined_metric_type = "KafkaBrokerStorageUtilization"
    }
  }
}

# security/firewall
resource "aws_security_group" "kafka" {
  name        = local.name
  description = format("security group for %s", local.name)
  vpc_id      = local.vpc
  tags        = merge(local.default-tags, var.tags)

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
