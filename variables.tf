
# username and password should be env variables. e.g:
# export TF_VAR_db_username=myuser
# export TF_VAR_db_password=mypassword

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


variable "db_username" {
  description = "The username for the database"
}

variable "db_password" {
  description = "The password for the database"
  sensitive   = true  // This hides the value from the Terraform output
}
