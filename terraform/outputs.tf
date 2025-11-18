output "test_load_balancer_dns" {
  description = "DNS del balanceador de carga de pruebas"
  value       = aws_lb.test.dns_name
}

output "prod_load_balancer_dns" {
  description = "DNS del balanceador de carga de producción"
  value       = aws_lb.prod.dns_name
}

output "test_ecr_repository_url" {
  description = "URL del repositorio ECR de pruebas"
  value       = aws_ecr_repository.test_app.repository_url
}

output "prod_ecr_repository_url" {
  description = "URL del repositorio ECR de producción"
  value       = aws_ecr_repository.prod_app.repository_url
}

output "codepipeline_name" {
  description = "Nombre del pipeline de CodePipeline"
  value       = aws_codepipeline.pipeline.name
}

output "ecs_cluster_name" {
  description = "Nombre del clúster de ECS"
  value       = aws_ecs_cluster.main.name
}
