# Pipeline CI/CD con AWS CodePipeline y ECS

Este proyecto implementa un pipeline completo de CI/CD en AWS utilizando:
- **CodePipeline**: Para orquestar el flujo de CI/CD
- **CodeBuild**: Para construir las imágenes Docker
- **ECS (Fargate)**: Para ejecutar los contenedores
- **ECR**: Para almacenar las imágenes Docker
- **Application Load Balancer**: Para balancear el tráfico en ambos ambientes
- **Terraform**: Para definir toda la infraestructura como código

## Arquitectura

El pipeline incluye las siguientes etapas:
1. **Source**: Obtiene el código desde GitHub
2. **Build**: Construye las imágenes Docker con CodeBuild
3. **ApproveTest**: Aprobación manual para desplegar en pruebas
4. **DeployTest**: Despliega en el ambiente de pruebas
5. **ApproveProd**: Aprobación manual para desplegar en producción
6. **DeployProd**: Despliega en el ambiente de producción

## Requisitos Previos

1. **Cuenta de AWS** con permisos de administrador
2. **AWS CLI** instalado y configurado
3. **Terraform** instalado (versión 1.0 o superior)
4. **Repositorio de GitHub** para el código fuente
5. **Token de GitHub** con permisos de `repo` y `admin:repo_hook`

## Configuración

### 1. Crear el repositorio en GitHub

```bash
# Inicializa git en este directorio
git init
git add .
git commit -m "Initial commit"

# Crea un repositorio en GitHub y luego:
git remote add origin https://github.com/tu-usuario/tu-repositorio.git
git branch -M main
git push -u origin main
```

### 2. Obtener Token de GitHub

1. Ve a GitHub > Settings > Developer settings > Personal access tokens
2. Genera un nuevo token (classic)
3. Selecciona los scopes: `repo` y `admin:repo_hook`
4. Copia el token generado

### 3. Configurar Variables de Terraform

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Edita `terraform.tfvars` con tus valores:

```terraform
aws_region     = "us-east-1"
github_owner   = "tu-usuario"
github_repo    = "tu-repositorio"
github_branch  = "main"
github_token   = "ghp_tu_token_aqui"
aws_account_id = "123456789012"
```

### 4. Configurar AWS CLI

```bash
aws configure
# Ingresa tu AWS Access Key ID
# Ingresa tu AWS Secret Access Key
# Ingresa tu región (ej: us-east-1)
# Ingresa el formato de salida (ej: json)
```

### 5. Desplegar la Infraestructura

```bash
cd terraform

# Inicializar Terraform
terraform init

# Ver el plan de ejecución
terraform plan

# Aplicar los cambios
terraform apply
```

Terraform te mostrará todos los recursos que va a crear. Escribe `yes` para confirmar.

## Uso del Pipeline

### Desencadenar el Pipeline

El pipeline se ejecuta automáticamente cada vez que hagas push a la rama configurada (por defecto `main`):

```bash
# Haz cambios en app/index.html
echo "<h1>Nueva versión</h1>" > app/index.html

git add .
git commit -m "Actualizar aplicación"
git push
```

### Aprobar Despliegues

1. Ve a la consola de AWS > CodePipeline
2. Selecciona el pipeline `app-pipeline`
3. Cuando llegue a la etapa `ApproveTest`, haz clic en **Review**
4. Escribe un comentario y haz clic en **Approve**
5. Repite el proceso para `ApproveProd`

### Acceder a las Aplicaciones

Después de desplegar, puedes acceder a las aplicaciones usando los DNS de los balanceadores de carga:

```bash
# Ver los outputs de Terraform
cd terraform
terraform output
```

Los DNS se verán así:
- **Test**: `http://test-lb-123456789.us-east-1.elb.amazonaws.com`
- **Prod**: `http://prod-lb-123456789.us-east-1.elb.amazonaws.com`

## Estructura del Proyecto

```
.
├── app/
│   ├── Dockerfile          # Define la imagen Docker
│   └── index.html          # Aplicación web simple
├── terraform/
│   ├── main.tf             # Recursos principales de AWS
│   ├── variables.tf        # Variables de entrada
│   ├── outputs.tf          # Outputs de Terraform
│   └── terraform.tfvars    # Valores de las variables (no incluido en git)
├── buildspec.yml           # Especificaciones de build para CodeBuild
└── README.md               # Este archivo
```

## Limpieza

Para eliminar todos los recursos creados y evitar cargos:

```bash
cd terraform
terraform destroy
```

Escribe `yes` para confirmar la eliminación.

## Notas Importantes

- Los balanceadores de carga pueden tardar 2-3 minutos en estar completamente disponibles
- Las imágenes Docker se construyen automáticamente en cada push
- Los roles de IAM usan `AdministratorAccess` por simplicidad; en producción deberías usar permisos más restrictivos
- El bucket S3 para artefactos tiene un nombre aleatorio para evitar conflictos

## Troubleshooting

### El pipeline falla en la etapa de Build

- Verifica que el repositorio de GitHub esté accesible
- Revisa los logs en CodeBuild para ver el error específico

### El despliegue a ECS falla

- Verifica que las imágenes se hayan subido correctamente a ECR
- Revisa los logs del servicio de ECS en CloudWatch

### No puedo acceder al balanceador de carga

- Espera 2-3 minutos después del despliegue
- Verifica que el security group permita tráfico en el puerto 80
- Verifica que las tareas de ECS estén en estado RUNNING

## Recursos Adicionales

- [AWS CodePipeline Documentation](https://docs.aws.amazon.com/codepipeline/)
- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
