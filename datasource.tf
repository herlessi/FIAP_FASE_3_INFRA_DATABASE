data "aws_iam_user" "principal_user" {
  user_name = "herlessi"
}

data "aws_eks_cluster" "cluster" {
  name = "eks-techchallenge-fiap-fase3-2153"
}

data "aws_eks_cluster_auth" "auth" {
  name = "eks-techchallenge-fiap-fase3-2153"
}

data "aws_vpc" "eks_vpc" {
  id = data.aws_eks_cluster.cluster.vpc_config[0].vpc_id
}

data "aws_subnets" "eks_private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks_vpc.id]
  }
}