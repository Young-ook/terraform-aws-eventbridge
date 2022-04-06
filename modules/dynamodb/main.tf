# dynamodb table

resource "aws_dynamodb_table" "db" {
  name           = var.name
  tags           = merge(local.default-tags, var.tags)
  billing_mode   = var.billing_mode
  hash_key       = lookup(var.key_schema, "hash_key")
  range_key      = lookup(var.key_schema, "range_key", null)
  read_capacity  = var.billing_mode == "PROVISIONED" ? lookup(var.scaling_config, "min_read_capacity") : null
  write_capacity = var.billing_mode == "PROVISIONED" ? lookup(var.scaling_config, "min_write_capacity") : null

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
