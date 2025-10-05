resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = data.aws_subnets.eks_private_subnets.ids

  tags = {
    Name = "rds-subnet-group"
  }
}