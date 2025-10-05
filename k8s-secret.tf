# Usando o provider kubernetes nativo para melhor compatibilidade com CI/CD
resource "kubernetes_secret" "database_secret" {
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

# Mantendo a versão kubectl_manifest como fallback comentada
# resource "kubectl_manifest" "database_secret" {
#   depends_on = [data.aws_eks_cluster.cluster]
#   yaml_body  = <<YAML
# apiVersion: v1
# kind: Secret
# metadata:
#   name: database-secret
# type: Opaque
# data:
#   password: bXlwYXNzd29yZDEyMw==  # base64 de 'mypassword123'
# YAML
# }