# Configuração de Recursos Kubernetes - Guia de Troubleshooting

Este projeto oferece múltiplas abordagens para criar recursos Kubernetes devido a problemas de autorização que podem ocorrer em ambientes CI/CD como GitHub Actions.

## Problema Identificado

O erro "Unauthorized" indica que o usuário/role do GitHub Actions não tem permissões suficientes para criar recursos Kubernetes diretamente através do provider do Terraform.

## Soluções Disponíveis

### 1. **Abordagem kubectl (RECOMENDADA)**
- **Arquivo**: `k8s-kubectl-alternative.tf`
- **Status**: ✅ Ativa por padrão
- **Como funciona**: Usa `null_resource` com `local-exec` para aplicar recursos via `kubectl`
- **Vantagens**: Contorna problemas de autorização do provider Kubernetes

### 2. **Abordagem Provider Kubernetes Nativo (DESABILITADA)**
- **Arquivos**: `k8s-configmap.tf`, `k8s-secret.tf`
- **Status**: ❌ Comentada devido a problemas de autorização
- **Como reativar**: Descomente os recursos e execute `terraform plan`

### 3. **Abordagem Condicional**
- **Arquivo**: `k8s-conditional.tf`
- **Status**: ❌ Desabilitada por padrão (`create_k8s_resources = false`)
- **Como ativar**: Use `-var="create_k8s_resources=true"`

## Variáveis de Controle

```hcl
# Para usar recursos Kubernetes condicionais
create_k8s_resources = true

# Para usar kubectl via local-exec (padrão)
apply_k8s_via_kubectl = true
```

## Como Executar

### Opção 1: Usar kubectl (Recomendado)
```bash
terraform plan
terraform apply -auto-approve
```

### Opção 2: Desabilitar recursos Kubernetes temporariamente
```bash
terraform apply -var="apply_k8s_via_kubectl=false" -auto-approve
```

### Opção 3: Testar provider nativo (se permissões forem corrigidas)
1. Descomente recursos em `k8s-configmap.tf` e `k8s-secret.tf`
2. Execute: `terraform apply -var="create_k8s_resources=true"`

## Recursos Criados

### ConfigMap: `database-fiap-fase3`
- **Namespace**: `default`
- **Dados**:
  - `POSTGRES_DB`: fiap_loja
  - `POSTGRES_USER`: myuser
  - `POSTGRES_HOST`: endereço do RDS
  - `POSTGRES_PORT`: 5432

### Secret: `database-secret`
- **Namespace**: `default`
- **Tipo**: Opaque
- **Dados**:
  - `password`: bXlwYXNzd29yZDEyMw== (base64 de 'mypassword123')

## Resolução Definitiva do Problema

Para resolver permanentemente o problema de autorização:

1. **Adicionar o role/user do GitHub Actions ao aws-auth ConfigMap do EKS**
2. **Conceder permissões adequadas para o namespace `default`**
3. **Verificar políticas IAM do usuário/role usado no GitHub Actions**

## Status Atual

- ✅ RDS PostgreSQL: Funcional
- ✅ Recursos Kubernetes via kubectl: Funcional
- ❌ Provider Kubernetes nativo: Problemas de autorização
- ✅ Outputs e validação: Funcionais