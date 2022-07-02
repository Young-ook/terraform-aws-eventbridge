# application autoscaling

### autoscaling/target
resource "aws_appautoscaling_target" "target" {
  max_capacity       = lookup(var.scaling_policy, "max_capacity", 10)
  min_capacity       = lookup(var.scaling_policy, "min_capacity", 5)
  resource_id        = lookup(var.scaling_policy, "resource_id")
  scalable_dimension = lookup(var.scaling_policy, "scalable_dimension")
  service_namespace  = lookup(var.scaling_policy, "service_namespace")
}

### autoscaling/policy
resource "aws_appautoscaling_policy" "policy" {
  name               = join("-", [local.name, aws_appautoscaling_target.target.resource_id])
  policy_type        = lookup(var.scaling_policy, "policy_type", "TargetTrackingScaling")
  resource_id        = lookup(var.scaling_policy, "resource_id")
  scalable_dimension = lookup(var.scaling_policy, "scalable_dimension")
  service_namespace  = lookup(var.scaling_policy, "service_namespace")

  dynamic "target_tracking_scaling_policy_configuration" {
    for_each = toset(lookup(var.scaling_policy, "policy_type") == "TargetTrackingScaling" ? ["enabled"] : [])
    content {
      target_value = lookup(var.scaling_policy, "target_value", 70)
      predefined_metric_specification {
        predefined_metric_type = lookup(var.scaling_policy, "predefined_metric_type")
      }
    }
  }
}
