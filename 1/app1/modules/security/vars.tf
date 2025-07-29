variable "project" {
  description = "value of the project name"
  type        = string
}

variable "env" {
  description = "value of the environment"
  type        = string
}

variable "vpc_id" {
  description = "value of the VPC ID"
}

variable "vpc_endpoint_allowed_cidrs" {
  description = "List of allowed CIDR blocks for security group ingress"
  type        = list(string)
}

variable "common_tags" {
  description = "Common tags to be applied to resources"
  type        = map(string)
}

variable "ecs_container_port" {
  description = "Container port for ECS tasks"
}

variable "ecs_allowed_cidr" {
  description = "List of allowed CIDR blocks for ECS security group ingress"
  type        = list(string)
}