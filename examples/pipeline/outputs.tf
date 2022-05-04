output "github_connection_status" {
  description = "The CodeStar Connection status. Possible values are PENDING, AVAILABLE and ERROR."
  value       = aws_codestarconnections_connection.github.connection_status
}
