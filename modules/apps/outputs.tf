output ecr_repo {
  value = aws_ecr_repository.repository.name
}

output app_lb {
  value = aws_lb.alb.dns_name
}
