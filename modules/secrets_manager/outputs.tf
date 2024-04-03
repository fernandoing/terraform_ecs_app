output "secret_arn" {
  description = "The ARN of the secret."
  value       = aws_secretsmanager_secret.example.arn
  sensitive   = true  # This will prevent the value from showing up in logs.
}

output "secret_version_id" {
  description = "The version identifier of the secret."
  value       = aws_secretsmanager_secret_version.example.version_id
  sensitive   = true  # This will prevent the value from showing up in logs.
}
