# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create an ECS cluster
resource "aws_ecs_cluster" "cluster" {
  name = "finapp-cluster"
}
