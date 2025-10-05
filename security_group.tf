resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow PostgreSQL access"
  vpc_id      = data.aws_vpc.eks_vpc.id


  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    # cidr_blocks = ["10.0.0.0/16"] # ou restrinja ao SG do EKS depois
    cidr_blocks = ["0.0.0.0/0"] # ou restrinja ao SG do EKS depois
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "rds-sg" }
}