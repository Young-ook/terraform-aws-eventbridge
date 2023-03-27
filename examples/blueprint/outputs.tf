output "event" {
  description = "Attributes of EventBridge event buses"
  value = {
    default-bus = module.default-eventbus
    custom-bus  = module.custom-eventbus
  }
}
