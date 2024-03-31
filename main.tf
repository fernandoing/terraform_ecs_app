provider "aws" {
  region = "us-east-1"
}

# AWS VPC
module "vpc" {
  source = "./modules/vpc"
  vpc_name = "finapp-vpc"
  vpc_cidr = var.vpc_cidr
  public_subnets_cidr = var.public_subnets_cidr
  tags = {
    Name = "finapp-vpc",
    Env = "dev",
  }
}

# Create an ECS cluster using the ecs module
module "ecs" {
  source = "./modules/ecs"
}

# Application to be deployed
module "app" {
  source = "./modules/apps"
  app_port = 80
  app_name = "frontent"
  aws_ecs_cluster = module.ecs.ecs_cluster
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets_ids
  desired_count = 2
  minimum_healthy_percent = 100
  maximum_percent = 200
  container_definition = file("./task_definitions/nginx.json")
}

# Relational db to hold transactions
module rds {
  source = "./modules/rds"
  region = "us-east-1"
  username = var.db_username
  password = var.db_password
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets_ids
  sg_cidr_blocks = [var.vpc_cidr]
}

# db dns to be consumed by application.
module "param" {
  source = "./modules/paramer_store"
  param_name = "finapp-db-dns"
  param_value = module.rds.db_endpoint
}
