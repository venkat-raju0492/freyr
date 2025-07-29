provider "aws" {
  region  = var.environment
} 
terraform {
   backend "s3" {}
 }

locals {
  # Common tags to be assigned to all resources
  common_tags = tomap({
    Project = var.project
    Environment = var.environment
    CreatedBy = "Terraform"
    CostCategory = var.cost_category
  })
}

 module "vpc" {
   source = "./modules/vpc-subnets-setup/"
   vpc_cidr = var.vpc_cidr
   public_subnet_cidr = var.public_subnet_cidr
   private_subnet_cidr = var.private_subnet_cidr
   vpc_id = module.vpc.vpc_id
   environment = var.environment 
   project = var.project
   common_tags = local.common_tags
   region = var.region
   route_ass_count = var.route_ass_count
   public_subnet_count = var.public_subnet_count
   private_subnet_count = var.private_subnet_count
 }
