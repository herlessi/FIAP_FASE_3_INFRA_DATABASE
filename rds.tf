resource "aws_db_instance" "rds_postgres" {
  identifier        = "my-postgres-db"
  engine            = "postgres"
  engine_version    = "17.4"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  db_name           = "fiap_loja"
  username          = jsondecode(aws_secretsmanager_secret_version.db_secret_version.secret_string).username
  password          = jsondecode(aws_secretsmanager_secret_version.db_secret_version.secret_string).password
  #   username            = "myuser"
  #   password            = "mypassword123"
  port     = 5432
  multi_az = false
  #   publicly_accessible = false
  publicly_accessible = true
  skip_final_snapshot = true

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name = "my-postgres-db"
  }
}