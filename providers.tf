terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}


provider "aws" {
  region = var.aws_region
}

# Provider kubectl mantido para compatibilidade futura
provider "kubectl" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.auth.token
  load_config_file       = false
  apply_retry_count      = 15
  
  # Configurações específicas para ambientes CI/CD
  insecure = false
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.auth.token
  
  # Configurações específicas para ambientes CI/CD
  insecure = false
  
  # Configurar namespace padrão
  ignore_annotations = [
    "kubectl.kubernetes.io/last-applied-configuration"
  ]
}
