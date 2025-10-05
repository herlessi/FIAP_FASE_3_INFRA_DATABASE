terraform {
  backend "s3" {
    bucket = "techchallenge-fiap-fase3-2153"
    key    = "techchallenge/fiap/fase3/rds/terraform.tfstate"
    region = "us-east-1"
  }
}