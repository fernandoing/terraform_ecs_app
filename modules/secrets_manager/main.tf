resource "aws_secretsmanager_secret" "example" {
  name        = var.secret_name
  description = var.secret_description
  kms_key_id  = "alias/aws/secretsmanager"
}

resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.example.id
  secret_string = var.secret_value
}
