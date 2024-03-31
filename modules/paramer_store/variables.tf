variable "param_name" {
  description = "The name of the parameter"
  type        = string
}

variable "param_type" {
  description = "The type of the parameter. Valid types are String, StringList and SecureString"
  type        = string
  default     = "String"
}

variable "param_value" {
  description = "The value of the parameter"
  type        = string
}

variable "param_desc" {
  description = "The description of the parameter"
  type        = string
  default     = ""
}
