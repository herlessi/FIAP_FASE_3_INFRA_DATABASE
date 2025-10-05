# Configurações adicionais para EKS e Kubernetes
# Este arquivo contém configurações específicas para resolver problemas de autorização

# Verificar se podemos listar recursos do cluster
data "kubernetes_service_account" "default" {
  depends_on = [data.aws_eks_cluster.cluster, data.aws_eks_cluster_auth.auth]
  
  metadata {
    name      = "default"
    namespace = "default"
  }
}

# Output para verificar informações do cluster
output "cluster_endpoint" {
  description = "Endpoint do cluster EKS"
  value       = data.aws_eks_cluster.cluster.endpoint
  sensitive   = false
}

output "cluster_status" {
  description = "Status do cluster EKS"
  value       = data.aws_eks_cluster.cluster.status
  sensitive   = false
}

output "cluster_version" {
  description = "Versão do cluster EKS"
  value       = data.aws_eks_cluster.cluster.version
  sensitive   = false
}

# Output para verificar se a autenticação está funcionando
output "auth_token_exists" {
  description = "Verifica se o token de autenticação existe"
  value       = data.aws_eks_cluster_auth.auth.token != null ? "Token exists" : "No token"
  sensitive   = true
}