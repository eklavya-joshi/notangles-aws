output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecs_service_name" {
  value = module.ecs.service_name
}

output "task_definition_family" {
  value = module.ecs.task_definition_family
}

output "task_definition_arn" {
  value = module.ecs.task_definition_arn
}

output "client_alb_dns_name" {
  value = module.ecs.client_alb_dns_name
}

output "github_actions_role_arn" {
  value = module.iam.github_actions_role_arn
}