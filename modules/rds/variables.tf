variable "region" {}

variable "allocated_storage" {
  type     = number
  default = 10
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "sg_cidr_blocks" {
  type     = list(string)
}

variable "storage_type" {
  type    = string
  default = "gp2"
}

variable "engine" {
  type     = string
  default = "mysql"
}

variable "engine_version" {
  type     = string
  default = "8.0"
}

variable "instance_type" {
  type     = string
  default = "db.t3.micro"
}
