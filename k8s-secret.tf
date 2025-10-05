resource "kubectl_manifest" "database_secret" {
  depends_on = [data.aws_eks_cluster.cluster]
  yaml_body  = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: database-secret
type: Opaque
data:
  password: bXlwYXNzd29yZDEyMw==  # base64 de 'mypassword123'
YAML
}