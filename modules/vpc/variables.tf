variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "vpc_name" {
  description = "The name that will be used for the vpc, igw and subnets."
  type = string
}

variable "tags" {
  description = "Common tags that will be added to all created resources"
  type = map(string)
}

