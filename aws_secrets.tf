resource "aws_secretsmanager_secret" "db_secret" {
  name = "rds-db-credentials7"
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = "myuser"
    password = "mypassword123"
  })
}