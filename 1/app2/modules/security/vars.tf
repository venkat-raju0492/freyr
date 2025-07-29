variable "project" {
  description = "value of the project"
  type        = string
}

variable "env" {
  description = "value of the environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the security group"
  type        = string
}

variable "vpc_endpoint_allowed_cidrs" {
  description = "CIDR blocks allowed to access the VPC endpoint"
  type        = list(string)
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
}