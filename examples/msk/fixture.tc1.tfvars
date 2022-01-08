aws_region = "ap-northeast-2"
name       = "lambda-eda-msk-custom-config"
tags = {
  env  = "dev"
  test = "tc1"
}
msk_config = {
  kafka_version   = "2.6.2"
  properties_file = "./custom.server.properties"
  monitoring = {
    prometheus_jmx_exporter_enabled  = true
    prometheus_node_exporter_enabled = true
  }
}
