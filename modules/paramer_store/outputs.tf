output "ssm_parameter_arn" {
  description = "The Amazon Resource Name (ARN) of the parameter"
  value       = aws_ssm_parameter.param.arn
}

output "ssm_parameter_version" {
  description = "The version of the parameter"
  value       = aws_ssm_parameter.param.version
}
