output "base_url" {
  value = "https://${aws_api_gateway_rest_api.api.id}.execute-api.${var.region}.amazonaws.com/${var.env}"
}  

output "api_id" {
  value = aws_api_gateway_rest_api.api.id
}

output "vpc_link_id" {
  value = aws_api_gateway_vpc_link.vpc_link.id
}