### output variables

output "layer" {
  description = "Attributes of lmabda layer"
  value       = aws_lambda_layer_version.layer
}
