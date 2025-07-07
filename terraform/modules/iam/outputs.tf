output "github_actions_role_arn" {
  value = aws_iam_role.github_actions_deploy.arn
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution.arn
}
