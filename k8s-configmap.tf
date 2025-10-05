resource "kubectl_manifest" "database_configmap" {
  depends_on = [data.aws_eks_cluster.cluster]
  yaml_body  = <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: database-fiap-fase3
data:
  POSTGRES_DB: fiap_loja
  POSTGRES_USER: myuser
  POSTGRES_HOST: ${aws_db_instance.rds_postgres.address}
  POSTGRES_PORT: '5432'
YAML
}