terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

locals {

  # Common tags to be assigned to all resources
  common_tags = {
    Project      = var.project
    Environment  = var.env
    CreatedBy    = "Terraform"
    CostCategory = "freyr"
  }

  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_ec2_transit_gateway" "tgw" {
  description                     = "TGW for connecting VPC1, VPC2, and VPC3"
  auto_accept_shared_attachments = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.env}-tgw"
  })
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc1_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = var.vpc1_id
  subnet_ids         = var.vpc1_subnet_ids

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.env}-vpc1-attachment"
  })
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc2_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = var.vpc2_id
  subnet_ids         = var.vpc2_subnet_ids

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.env}-vpc2-attachment"
  })
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc3_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = var.vpc3_id
  subnet_ids         = var.vpc3_subnet_ids

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.env}-vpc3-attachment"
  })
}

resource "aws_route" "vpc1_to_vpc2" {
    route_table_id          = var.vpc1_route_table_id
    destination_cidr_block  = var.vpc2_cidr_block
    transit_gateway_id      = aws_ec2_transit_gateway.tgw.id
}

resource "aws_route" "vpc1_to_vpc3" {
    route_table_id          = var.vpc1_route_table_id
    destination_cidr_block  = var.vpc3_cidr_block
    transit_gateway_id      = aws_ec2_transit_gateway.tgw.id
}

resource "aws_route" "vpc2_to_vpc1" {
    route_table_id          = var.vpc2_route_table_id
    destination_cidr_block  = var.vpc1_cidr_block
    transit_gateway_id      = aws_ec2_transit_gateway.tgw.id
}  

resource "aws_route" "vpc2_to_vpc3" {
    route_table_id          = var.vpc2_route_table_id
    destination_cidr_block  = var.vpc3_cidr_block
    transit_gateway_id      = aws_ec2_transit_gateway.tgw.id
}   

resource "aws_route" "vpc3_to_vpc1" {
    route_table_id          = var.vpc3_route_table_id
    destination_cidr_block  = var.vpc1_cidr_block
    transit_gateway_id      = aws_ec2_transit_gateway.tgw.id
}

resource "aws_route" "vpc3_to_vpc2" {
    route_table_id          = var.vpc3_route_table_id
    destination_cidr_block  = var.vpc2_cidr_block
    transit_gateway_id      = aws_ec2_transit_gateway.tgw.id
}

