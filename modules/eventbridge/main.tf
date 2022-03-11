resource "aws_cloudwatch_event_bus" "bus" {
  for_each          = local.bus
  name              = lookup(local.bus, "name")
  tags              = merge(local.default-tags, var.tags)
  event_source_name = lookup(local.bus, "event_source_name", local.default_bus.event_source_name)
}

# event rules
# At least one of `schedule_expression` or `event_pattern` is required.
resource "aws_cloudwatch_event_rule" "rule" {
  for_each            = { for e in var.rules : e.name => e }
  name                = join("-", [local.name, each.key])
  tags                = merge(local.default-tags, var.tags)
  description         = lookup(each.value, "description", null)
  schedule_expression = lookup(each.value, "schedule_expression", local.default_rule.schedule_expression)
  event_pattern       = lookup(each.value, "event_pattern", local.default_rule.event_pattern)
}
