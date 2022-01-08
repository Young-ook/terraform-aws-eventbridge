# default variables

locals {
  default_vpc_config = {
    vpc             = null
    subnets         = null
    security_groups = []
  }
  default_cluster_config = {
    kafka_version  = "2.6.2"
    instance_count = "3"              # number of broker nodes
    instance_type  = "kafka.m5.large" # ec2 instance type for broker node
    disk_size      = 1000             # ebs disk size in GB
    scaling_policy = {
      max_disk_size    = 2000
      tracking_target  = 80
      disable_scale_in = true
    }
    monitoring = {
      prometheus_jmx_exporter_enabled  = false
      prometheus_node_exporter_enabled = false
    }
  }
  default_log_config = {
    cloudwatch_logs = {
      enabled   = false
      log_group = null
    }
    firehose = {
      enabled         = false
      delivery_stream = null
    }
    s3 = {
      enabled = false
      bucket  = null
      prefix  = null
    }
  }
}