variable "vpc_cidr" {
    description = "VPC CIDR for DR Account" 
}

variable "public_subnet_cidr" {
    type=list(string)
}

variable "private_subnet_cidr" {
    type=list(string)
}

variable "region" {
    description = "Region for your resources" 
}

variable "environment" {
    description = "The name for environment"
}

variable "project" {
    description = "The name for the project"
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

