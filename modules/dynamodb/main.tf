### dynamodb table

### database/table
resource "aws_dynamodb_table" "db" {
  name           = var.name
  tags           = merge(local.default-tags, var.tags)
  billing_mode   = var.billing_mode
  hash_key       = lookup(var.key_schema, "hash_key")
  range_key      = lookup(var.key_schema, "range_key", null)
  read_capacity  = var.billing_mode == "PROVISIONED" ? lookup(var.scaling, "max_read_capacity", 10) : null
  write_capacity = var.billing_mode == "PROVISIONED" ? lookup(var.scaling, "max_write_capacity", 10) : null

  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indices
    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      projection_type    = global_secondary_index.value.projection_type
      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", null)
      range_key          = lookup(global_secondary_index.value, "range_key", null)
      read_capacity      = lookup(global_secondary_index.value, "read_capacity", null)
      write_capacity     = lookup(global_secondary_index.value, "write_capacity", null)
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indices
    content {
      name               = local_secondary_index.value.name
      range_key          = local_secondary_index.value.range_key
      projection_type    = local_secondary_index.value.projection_type
      non_key_attributes = lookup(local_secondary_index.value, "non_key_attributes", null)
    }
  }

  ttl {
    attribute_name = lookup(var.ttl, "attribute", null)
    enabled        = lookup(var.ttl, "enabled", false)
  }

  server_side_encryption {
    enabled     = lookup(var.server_side_encryption, "enabled", false)
    kms_key_arn = lookup(var.server_side_encryption, "kms_key_arn", null)
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery
  }

  lifecycle {
    ignore_changes = [read_capacity, write_capacity]
  }
}

### autoscaling/policy
module "rcu_scaling" {
  for_each = toset(var.billing_mode == "PROVISIONED" ? ["enabled"] : [])
  source   = "./modules/autoscaling"
  name     = join("-", [local.name, "dynamodb-rcu"])
  scaling_policy = {
    max_capacity           = lookup(var.scaling, "max_read_capacity", 10)
    min_capacity           = lookup(var.scaling, "min_read_capacity", 5)
    resource_id            = join("/", ["table", aws_dynamodb_table.db.id])
    scalable_dimension     = "dynamodb:table:ReadCapacityUnits"
    service_namespace      = "dynamodb"
    policy_type            = "TargetTrackingScaling"
    predefined_metric_type = "DynamoDBReadCapacityUtilization"
    target_value           = lookup(var.scaling, "read_target", 70)
  }
}

module "wcu_scaling" {
  for_each = toset(var.billing_mode == "PROVISIONED" ? ["enabled"] : [])
  source   = "./modules/autoscaling"
  name     = join("-", [local.name, "dynamodb-wcu"])
  scaling_policy = {
    max_capacity           = lookup(var.scaling, "max_write_capacity", 10)
    min_capacity           = lookup(var.scaling, "min_write_capacity", 5)
    resource_id            = join("/", ["table", aws_dynamodb_table.db.id])
    scalable_dimension     = "dynamodb:table:WriteCapacityUnits"
    service_namespace      = "dynamodb"
    policy_type            = "TargetTrackingScaling"
    predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    target_value           = lookup(var.scaling, "write_target", 70)
  }
}
