output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC"
}

output "public_subnets_ids" {
  value       = aws_subnet.public.*.id
  description = "The IDs of the public subnets"
}

output "default_security_group_id" {
  value       = aws_default_security_group.default.id
  description = "The ID of the default security group"
}
