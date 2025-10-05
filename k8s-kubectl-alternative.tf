# Solução alternativa usando kubectl via local-exec
# Esta abordagem contorna problemas de autorização do provider Kubernetes

# Variável para controlar a aplicação via kubectl
variable "apply_k8s_via_kubectl" {
  description = "Aplica recursos Kubernetes usando kubectl via local-exec"
  type        = bool
  default     = true
}

# Criar arquivos YAML temporários e aplicá-los via kubectl
resource "null_resource" "k8s_configmap_kubectl" {
  count = var.apply_k8s_via_kubectl ? 1 : 0
  
  depends_on = [aws_db_instance.rds_postgres]
  
  triggers = {
    postgres_host = aws_db_instance.rds_postgres.address
    always_run    = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      # Configurar kubectl para usar o cluster EKS
      aws eks update-kubeconfig --region ${var.aws_region} --name eks-techchallenge-fiap-fase3-2153 --kubeconfig /tmp/kubeconfig
      
      # Criar ConfigMap
      cat <<EOF | kubectl apply -f - --kubeconfig /tmp/kubeconfig
apiVersion: v1
kind: ConfigMap
metadata:
  name: database-fiap-fase3
  namespace: default
  labels:
    app: fiap-database
    managed: terraform
data:
  POSTGRES_DB: "fiap_loja"
  POSTGRES_USER: "myuser"
  POSTGRES_HOST: "${aws_db_instance.rds_postgres.address}"
  POSTGRES_PORT: "5432"
EOF
    EOT
    
    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      # Configurar kubectl para o destroy
      aws eks update-kubeconfig --region us-east-1 --name eks-techchallenge-fiap-fase3-2153 --kubeconfig /tmp/kubeconfig || true
      
      # Remover ConfigMap
      kubectl delete configmap database-fiap-fase3 --namespace default --kubeconfig /tmp/kubeconfig || true
      
      # Limpar kubeconfig temporário
      rm -f /tmp/kubeconfig || true
    EOT
    
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "null_resource" "k8s_secret_kubectl" {
  count = var.apply_k8s_via_kubectl ? 1 : 0
  
  depends_on = [aws_db_instance.rds_postgres]
  
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOT
      # Configurar kubectl para usar o cluster EKS
      aws eks update-kubeconfig --region ${var.aws_region} --name eks-techchallenge-fiap-fase3-2153 --kubeconfig /tmp/kubeconfig
      
      # Criar Secret
      cat <<EOF | kubectl apply -f - --kubeconfig /tmp/kubeconfig
apiVersion: v1
kind: Secret
metadata:
  name: database-secret
  namespace: default
  labels:
    app: fiap-database
    managed: terraform
type: Opaque
data:
  password: bXlwYXNzd29yZDEyMw==
EOF
    EOT
    
    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      # Configurar kubectl para o destroy
      aws eks update-kubeconfig --region us-east-1 --name eks-techchallenge-fiap-fase3-2153 --kubeconfig /tmp/kubeconfig || true
      
      # Remover Secret
      kubectl delete secret database-secret --namespace default --kubeconfig /tmp/kubeconfig || true
      
      # Limpar kubeconfig temporário
      rm -f /tmp/kubeconfig || true
    EOT
    
    interpreter = ["/bin/bash", "-c"]
  }
}

# Outputs para a solução kubectl
output "kubectl_configmap_applied" {
  description = "ConfigMap aplicado via kubectl"
  value       = var.apply_k8s_via_kubectl ? "ConfigMap aplicado via kubectl com sucesso" : "ConfigMap não aplicado (apply_k8s_via_kubectl = false)"
}

output "kubectl_secret_applied" {
  description = "Secret aplicado via kubectl"
  value       = var.apply_k8s_via_kubectl ? "Secret aplicado via kubectl com sucesso" : "Secret não aplicado (apply_k8s_via_kubectl = false)"
  sensitive   = true
}