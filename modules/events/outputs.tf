output "eventbridge" {
  description = "The attributes of generated event bridge"
  value = zipmap(
    ["bus", "rule"],
    [aws_cloudwatch_event_bus.bus, aws_cloudwatch_event_rule.rule]
  )
}
