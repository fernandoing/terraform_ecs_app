output "ecs_cluster_id" {
  value = module.ecs.ecs_cluster # This uses the output name from the module output. I cant call the outputs of the resource directly.
}

output "application_dns" {
  value = module.frontend_app.app_lb
}

output "backend_dns" {
  value = module.backend_app.app_lb
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}
