# Usando o provider kubernetes nativo para melhor compatibilidade com CI/CD
resource "kubernetes_config_map" "database_configmap" {
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

# Mantendo a versão kubectl_manifest como fallback comentada
# resource "kubectl_manifest" "database_configmap" {
#   depends_on = [data.aws_eks_cluster.cluster]
#   yaml_body  = <<YAML
# apiVersion: v1
# kind: ConfigMap
# metadata:
#   name: database-fiap-fase3
# data:
#   POSTGRES_DB: fiap_loja
#   POSTGRES_USER: myuser
#   POSTGRES_HOST: ${aws_db_instance.rds_postgres.address}
#   POSTGRES_PORT: '5432'
# YAML
# }