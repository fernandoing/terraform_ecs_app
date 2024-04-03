variable "secret_name" {
  description = "The name of the secret."
  type        = string
}

variable "secret_description" {
  description = "The description of the secret."
  type        = string
  default     = ""
}

variable "secret_value" {
  description = "The value of the secret."
  type        = string
  sensitive   = true  # This will prevent the value from showing up in logs.
}
