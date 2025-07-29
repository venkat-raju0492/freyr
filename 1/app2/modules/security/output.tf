output "vpc_endpoint_sg_id" {
  value = aws_security_group.vpc_endpoint_sg.id
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda-role.arn
}