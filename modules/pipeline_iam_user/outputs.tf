output "iam_user_name" {
  description = "The name of the IAM user."
  value       = aws_iam_user.pipeline.name
}

output "access_key" {
  description = "The access key of the IAM user."
  value       = aws_iam_access_key.pipeline.id
  sensitive   = true
}

output "secret_access_key" {
  description = "The secret access key of the IAM user."
  value       = aws_iam_access_key.pipeline.secret
  sensitive   = true
}
