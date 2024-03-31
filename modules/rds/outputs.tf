output "db_endpoint" {
  description = "The RDS instance endpoint"
  value       = aws_db_instance.instance.endpoint
}
