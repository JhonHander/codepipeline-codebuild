<div align="center">

<!-- Banner del Proyecto - Reemplazar con tu imagen -->
<!-- <img src="docs/images/banner.png" alt="Project Banner" width="100%"> -->

# 🚀 Pipeline CI/CD con AWS CodePipeline y ECS

[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-web-services&logoColor=white)](https://aws.amazon.com/)
[![Terraform](https://img.shields.io/badge/Terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Docker](https://img.shields.io/badge/Docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg?style=flat-square)](https://github.com/JhonHander/codepipeline-codebuild/graphs/commit-activity)

**Pipeline de integración y despliegue continuo completamente automatizado en AWS**

[Documentación](#%EF%B8%8F-configuración) •
[Arquitectura](#-arquitectura) •
[Uso](#-uso-del-pipeline)

</div>

---

## ✨ Características

| Servicio | Descripción |
|----------|-------------|
| **CodePipeline** | Orquestación del flujo CI/CD |
| **CodeBuild** | Construcción de imágenes Docker |
| **ECS (Fargate)** | Ejecución de contenedores serverless |
| **ECR** | Almacenamiento de imágenes Docker |
| **Application Load Balancer** | Balanceo de tráfico en ambos ambientes |
| **Terraform** | Infraestructura como código |

---

## 🏗 Arquitectura

El pipeline incluye las siguientes etapas:
1. **Source**: Obtiene el código desde GitHub
2. **Build**: Construye las imágenes Docker con CodeBuild
3. **ApproveTest**: Aprobación manual para desplegar en pruebas
4. **DeployTest**: Despliega en el ambiente de pruebas
5. **ApproveProd**: Aprobación manual para desplegar en producción
6. **DeployProd**: Despliega en el ambiente de producción

---

## 📋 Requisitos Previos

> [!IMPORTANT]
> Asegúrate de tener configurados los siguientes requisitos antes de comenzar.

- 🔑 **Cuenta de AWS** con permisos de administrador
- 💻 **AWS CLI** instalado y configurado
- 🛠️ **Terraform** instalado (versión 1.0 o superior)
- 📦 **Repositorio de GitHub** para el código fuente

---

## ⚙️ Configuración

### 1. Crear el repositorio en GitHub

<details>
<summary>📁 Ver instrucciones</summary>

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

</details>

### 2. Configurar Variables de Terraform

<details>
<summary>📁 Ver instrucciones</summary>

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Edita `terraform.tfvars` con tus valores:

```terraform
aws_region           = "us-east-1"
github_repository_id = "tu-usuario/tu-repositorio"  # Formato: owner/repo
github_branch        = "main"
aws_account_id       = "123456789012"
```

> [!NOTE]
> Ya no necesitas un token de GitHub. La conexión se maneja automáticamente a través de AWS CodeStar Connections.

</details>

### 3. Configurar AWS CLI

<details>
<summary>📁 Ver instrucciones</summary>

```bash
aws configure
# Ingresa tu AWS Access Key ID
# Ingresa tu AWS Secret Access Key
# Ingresa tu región (ej: us-east-1)
# Ingresa el formato de salida (ej: json)
```

</details>

### 4. Desplegar la Infraestructura

<details>
<summary>📁 Ver instrucciones</summary>

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

</details>

### 5. Autorizar la Conexión de GitHub

<details>
<summary>📁 Ver instrucciones</summary>

Después de ejecutar `terraform apply`, tendrás que autorizar la conexión de AWS en GitHub:

1. Ve a la consola de AWS > **CodePipeline** > **Connections**
2. Busca la conexión `github-connection` con estado **PENDING**
3. Haz clic en **Update pending connection**
4. Haz clic en **Connect to GitHub** e instala la aplicación de AWS CodePipeline en tu cuenta de GitHub
5. Una vez autorizada, el estado cambiará a **AVAILABLE**

</details>

---

## 🚀 Uso del Pipeline

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

Después de desplegar, accede a las aplicaciones usando los DNS de los balanceadores de carga:

```bash
cd terraform
terraform output
```

| Ambiente | URL Ejemplo |
|----------|-------------|
| **Test** | `http://test-lb-123456789.us-east-1.elb.amazonaws.com` |
| **Prod** | `http://prod-lb-123456789.us-east-1.elb.amazonaws.com` |

---

## 📁 Estructura del Proyecto

```
.
├── 📂 app/
│   ├── Dockerfile          # Define la imagen Docker
│   └── index.html          # Aplicación web simple
├── 📂 terraform/
│   ├── main.tf             # Recursos principales de AWS
│   ├── variables.tf        # Variables de entrada
│   ├── outputs.tf          # Outputs de Terraform
│   └── terraform.tfvars    # Valores de las variables
├── buildspec.yml           # Especificaciones de CodeBuild
└── README.md               # Este archivo
```

---

## 🧹 Limpieza

Para eliminar todos los recursos creados y evitar cargos:

```bash
cd terraform
terraform destroy
```

> [!WARNING]
> Escribe `yes` para confirmar la eliminación. Esta acción es irreversible.

---

## 📝 Notas Importantes

> [!TIP]
> - Los balanceadores de carga pueden tardar 2-3 minutos en estar completamente disponibles
> - Las imágenes Docker se construyen automáticamente en cada push
> - Los roles de IAM usan `AdministratorAccess` por simplicidad; en producción usa permisos más restrictivos
> - El bucket S3 para artefactos tiene un nombre aleatorio para evitar conflictos

---

## 🔧 Troubleshooting

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

---

## 📚 Recursos Adicionales

| Recurso | Enlace |
|---------|--------|
| AWS CodePipeline | [Documentación](https://docs.aws.amazon.com/codepipeline/) |
| AWS ECS | [Documentación](https://docs.aws.amazon.com/ecs/) |
| Terraform AWS Provider | [Documentación](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) |

---

<div align="center">

**⭐ Si este proyecto te resultó útil, considera darle una estrella ⭐**

</div>
