provider "aws" {
  region = "us-east-1"
}

# AWS VPC
module "vpc" {
  source              = "./modules/vpc"
  vpc_name            = "finapp-vpc"
  vpc_cidr            = var.vpc_cidr
  public_subnets_cidr = var.public_subnets_cidr
  tags = {
    Name = "finapp-vpc",
    Env  = "dev",
  }
}

# Create an ECS cluster using the ecs module
module "ecs" {
  source = "./modules/ecs"
}

# Application to be deployed
module "backend_app" {
  source                  = "./modules/apps"
  app_port                = 5000
  app_name                = "finapp-gpt-backend"
  aws_ecs_cluster         = module.ecs.ecs_cluster
  vpc_id                  = module.vpc.vpc_id
  subnets                 = module.vpc.public_subnets_ids
  desired_count           = 1
  minimum_healthy_percent = 100
  maximum_percent         = 200
  container_definition    = file("./task_definitions/finapp-gpt-backend.json")
  health_path             = "/healthz"
  secret_arn              = module.backend_secret_config.secret_arn
}

# Application to be deployed
module "frontend_app" {
  source                  = "./modules/apps"
  app_port                = 8080
  app_name                = "finapp-gpt-frontend"
  aws_ecs_cluster         = module.ecs.ecs_cluster
  vpc_id                  = module.vpc.vpc_id
  subnets                 = module.vpc.public_subnets_ids
  desired_count           = 1
  minimum_healthy_percent = 100
  maximum_percent         = 200
  container_definition    = file("./task_definitions/finapp-gpt-frontend.json")
  health_path             = "/login"
  secret_arn              = module.frontend_secret_config.secret_arn
}

# Relational db to hold transactions
module "rds" {
  source         = "./modules/rds"
  region         = "us-east-1"
  username       = var.db_username
  password       = var.db_password
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.public_subnets_ids
  sg_cidr_blocks = ["0.0.0.0/0"]
  #sg_cidr_blocks = [var.vpc_cidr]
}

# db dns to be consumed by application.
module "param" {
  source      = "./modules/paramer_store"
  param_name  = "finapp-db-dns"
  param_value = module.rds.db_endpoint
}

module "pipeline_iam_user" {
  source        = "./modules/pipeline_iam_user"
  iam_user_name = "pipeline-iam-user"

}

module "secret" {
  source             = "./modules/secrets_manager"
  secret_description = "Database password"
  secret_name        = "finapp-db-password"
  secret_value       = "REPLACEME"
}

module "secret_iam_user" {
  source             = "./modules/secrets_manager"
  secret_description = "Database password"
  secret_name        = "pipeline-iam-user-credentials"
  secret_value = jsonencode({
    access_key = module.pipeline_iam_user.access_key,
    secret_key = module.pipeline_iam_user.secret_access_key
  })
}

module "db_secret_config" {
  source             = "./modules/secrets_manager"
  secret_description = "Database details"
  secret_name        = "db_secret_config"
  secret_value = jsonencode({
    username = var.db_username
    password = var.db_password
    jwt_key  = var.jwt_key
    db_host  = module.rds.db_endpoint
    db_port  = "3306"
  })
}

module "backend_secret_config" {
  source             = "./modules/secrets_manager"
  secret_description = "Secrets regarding backend"
  secret_name        = "backend_secret_config"
  secret_value = jsonencode({
    gpt_key = var.db_username
    api_url = "https://yc70onuuyh.execute-api.us-east-1.amazonaws.com/dev"
  })
}

module "frontend_secret_config" {
  source             = "./modules/secrets_manager"
  secret_description = "Secrets regarding backend"
  secret_name        = "frontend_secret_config"
  secret_value = jsonencode({
    VITE_API_URL   = module.backend_app.app_lb
    VITE_API_LOGIN = "https://yc70onuuyh.execute-api.us-east-1.amazonaws.com/dev"
  })
}


module "lambda" {
  source = "./modules/lambda"
  secret_name = "db_secret_config"
  lambdasVersion = "0.1"
}
