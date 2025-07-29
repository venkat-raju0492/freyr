# Overview

This module will do the following:
- Setup one VPC with the required number of subnets
- Setup route tables, which includes route table association 
- Setup a NAT gateway and attach to private route table


## Inputs required for for this VPC Setup from Jenkins job

- Project Name
- Environment
- Region
- S3 Bucket Name for tfstat location

### Any team can use this folder directly by adding tfvars with the VPC CIDR and Subnet CIDR values

You can use this module by adding a below code on your main.tf

```

module "vpc" {
   source = "./../../terraform/vpc-subnets-setup/"
   vpc_cidr = "${var.vpc_cidr}"
   public_subnet_cidr = "${var.public_subnet_cidr}"
   private_subnet_cidr = "${var.private_subnet_cidr}"
   environment = "${var.environment}" 
   project = "${var.project}"
   common_tags = "${local.common_tags}"
 }


```