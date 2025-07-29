resource "aws_vpc_endpoint" "vpc_endpoint" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.execute-api"
  vpc_endpoint_type = "Interface"

  security_group_ids = [var.vpc_endpoint_sg_id]

  subnet_ids          = var.private_subnet_ids
  private_dns_enabled = false

  tags = merge(var.common_tags, tomap({
    Name = "${var.project}-vpc-endpoint-${var.env}"
  }))
}