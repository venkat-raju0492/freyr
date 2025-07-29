variable "region" {
  description = "value of the AWS region to deploy resources in"
}

variable "project" {
  description = "Name of the project"     
}

variable "env" {
  description = "Environment (e.g., dev, staging, prod)"
}

variable "vpc1_id" {
  description = "ID of VPC1"
}

variable "vpc1_subnet_ids" {
  description = "List of subnet IDs for VPC1"
  type        = list(string)
}

variable "vpc2_id" {
  description = "ID of VPC2"
}

variable "vpc2_subnet_ids" {
  description = "List of subnet IDs for VPC2"
  type        = list(string)
}

variable "vpc3_id" {
  description = "ID of VPC3"
}

variable "vpc3_subnet_ids" {
  description = "List of subnet IDs for VPC3"
  type        = list(string)    
}

variable "vpc1_route_table_id" {
  description = "Route table ID for VPC1"
}

variable "vpc2_route_table_id" {
  description = "Route table ID for VPC2"
}

variable "vpc3_route_table_id" {
  description = "Route table ID for VPC3"
}

variable "vpc1_cidr_block" {
  description = "CIDR block for VPC1"
}

variable "vpc2_cidr_block" {
  description = "CIDR block for VPC2"
}

variable "vpc3_cidr_block" {
  description = "CIDR block for VPC3"
}