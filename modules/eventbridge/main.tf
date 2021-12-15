resource "aws_cloudwatch_event_bus" "bus" {
  for_each          = local.bus_config
  name              = lookup(local.bus_config, "name")
  tags              = merge(local.default-tags, var.tags)
  event_source_name = lookup(local.bus_config, "event_source_name", local.default_bus_config.event_source_name)
}

# event rules
# At least one of `schedule_expression` or `event_pattern` is required.
resource "aws_cloudwatch_event_rule" "rule" {
  name                = local.name
  tags                = merge(local.default-tags, var.tags)
  schedule_expression = lookup(local.rule_config, "schedule_expression", local.default_rule_config.schedule_expression)
  event_pattern       = lookup(local.rule_config, "event_pattern", local.default_rule_config.event_pattern)
}
