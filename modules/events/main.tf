resource "aws_cloudwatch_event_bus" "bus" {
  for_each          = local.bus_config
  name              = lookup(local.bus_config, "name", local.default_bus_config.name)
  event_source_name = lookup(local.bus_config, "event_source_name", local.default_bus_config.event_source_name)
  tags              = merge(local.default-tags, var.tags)
}

resource "aws_cloudwatch_event_rule" "rule" {
  name                = local.name
  schedule_expression = lookup(local.rule_config, "schedule_expression", null)
}
