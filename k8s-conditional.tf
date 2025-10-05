# Arquivo para configurações específicas do GitHub Actions
# Este arquivo contém workarounds para problemas de autorização em CI/CD

# Variável para controlar se deve criar recursos Kubernetes
variable "create_k8s_resources" {
  description = "Controla se deve criar recursos Kubernetes (útil para troubleshooting)"
  type        = bool
  default     = false  # Desabilitado por padrão devido a problemas de autorização
}

# Recurso condicional para ConfigMap
resource "kubernetes_config_map" "database_configmap_conditional" {
  count      = var.create_k8s_resources ? 1 : 0
  depends_on = [data.aws_eks_cluster.cluster, data.aws_eks_cluster_auth.auth]
  
  metadata {
    name      = "database-fiap-fase3"
    namespace = "default"
    
    labels = {
      app     = "fiap-database"
      managed = "terraform"
    }
  }

  data = {
    POSTGRES_DB   = "fiap_loja"
    POSTGRES_USER = "myuser"
    POSTGRES_HOST = aws_db_instance.rds_postgres.address
    POSTGRES_PORT = "5432"
  }
}

# Recurso condicional para Secret
resource "kubernetes_secret" "database_secret_conditional" {
  count      = var.create_k8s_resources ? 1 : 0
  depends_on = [data.aws_eks_cluster.cluster, data.aws_eks_cluster_auth.auth]
  
  metadata {
    name      = "database-secret"
    namespace = "default"
    
    labels = {
      app     = "fiap-database"
      managed = "terraform"
    }
  }

  type = "Opaque"

  data = {
    password = "bXlwYXNzd29yZDEyMw=="  # base64 de 'mypassword123'
  }
}

# Outputs condicionais
output "configmap_created" {
  description = "ConfigMap foi criado"
  value       = var.create_k8s_resources ? "ConfigMap criado com sucesso" : "ConfigMap não criado (create_k8s_resources = false)"
}

output "secret_created" {
  description = "Secret foi criado"
  value       = var.create_k8s_resources ? "Secret criado com sucesso" : "Secret não criado (create_k8s_resources = false)"
  sensitive   = true
}