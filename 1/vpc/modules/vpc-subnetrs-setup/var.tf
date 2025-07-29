variable "common_tags" {
  description = "Common tags to apply to all resources"
  type = map(string)
}
variable "vpc_cidr" {
    description = "VPC CIDR for DR Account" 
}
variable "route_ass_count" {
    default = "3"
    description = "Route table association count"
}
variable "public_subnet_count" {
    default = "3"
    description = "Number of Public subnets needed"
}
variable "private_subnet_count" {
    default = "3"
    description = "Number of Private subnets needed"
}
variable "public_subnet_cidr" {
    type=list(string)
}
variable "private_subnet_cidr" {
    type=list(string)  
}
variable "environment" {
    description = "The name for environment"
}
variable "enable_dns_hostnames" {
    default = "true"
    description = "Enable DNS hostnames for VPC true/false"
}
variable "enable_dns_support" {
    default = "true"
    description = "Enable DNS support for VPC true/false"
}
variable "project" {
    description = "The name for the project"
}
variable "region" {
    description = "The region name"
}
variable "traffic_type" {
  default = "ALL"
  description = "VPC flow log type"
}
variable "log_group_name" {
  default = ""
  description = "Defaults to `$${default_log_group_name}`"
}
locals {
  default_log_group_name = "${var.project}-vpc-flow-log"
}
variable "vpc_id" {
    description = "VPC ID" 
}
variable "public_ip_on_launch" {
    default = "false"
    description = "Enable public IP at launch true/false"
}