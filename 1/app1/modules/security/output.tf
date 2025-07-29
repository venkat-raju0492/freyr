output "vpc_endpoint_sg_id" {
  value = aws_security_group.vpc_endpoint_sg.id
}

output "ecs-task-role-arn" {
  value = aws_iam_role.ecs-task-role.arn
}

output "asg-sg-api-id" {
  value = aws_security_group.asg-sg.id
}

output "api_cw_role_arn" {
  value = aws_iam_role.apigateway_cloudwatch.arn
  
}