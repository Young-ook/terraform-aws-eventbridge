aws_region = "ap-northeast-2"
tags = {
  env = "dev"
}
msk_config = {
  kafka_version = "2.6.2"
  monitoring = {
    prometheus_jmx_exporter_enabled  = false
    prometheus_node_exporter_enabled = true
  }
}
