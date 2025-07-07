output "cluster_name" {
  value = aws_ecs_cluster.client.name
}

output "service_name" {
  value = aws_ecs_service.client.name
}

output "task_definition_family" {
  value = aws_ecs_task_definition.client.family
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.client.arn
}

output "client_alb_dns_name" {
  value = aws_lb.client_alb.dns_name
}