variable "app_name" {
  type = string
}

variable "app_port" {
  type = number
}

variable "vpc_id" {
  type = string
}

variable  "aws_ecs_cluster" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "minimum_healthy_percent" {
  type    = number
  default = 50
}

variable "maximum_percent" {
  type    = number
  default = 200
}

variable "container_definition" {
  
}
