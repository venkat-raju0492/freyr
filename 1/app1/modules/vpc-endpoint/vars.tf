variable "vpc_id" {
  description = "value of the VPC ID"
  type        = string
}

variable "region" {
  description = "value of the region"
  type        = string
}

variable "vpc_endpoint_sg_id" {
  description = "ID of the security group for VPC endpoint"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "common_tags" {
  description = "Common tags to be applied to resources"
  type        = map(string)
}

variable "project" {
  description = "Name of the project"
  type        = string
}

variable "env" {
  description = "Name of the environment"
  type        = string
}