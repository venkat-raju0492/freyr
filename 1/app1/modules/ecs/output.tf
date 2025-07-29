output "cluster_id" {
  value = length(aws_ecs_cluster.application_ecs_cluster) > 0 ? aws_ecs_cluster.application_ecs_cluster[0].id : ""
}

output "cluster_arn" {
  value = length(aws_ecs_cluster.application_ecs_cluster) > 0 ? aws_ecs_cluster.application_ecs_cluster[0].arn : ""
}

output "cluster_name" {
  value = length(aws_ecs_cluster.application_ecs_cluster) > 0 ? aws_ecs_cluster.application_ecs_cluster[0].name : ""
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.application_ecs_task_definition.arn
}