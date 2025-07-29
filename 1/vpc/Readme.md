Terraform script to create 3 VPC's

Prerequisites.

AWS Account with all required set of permissions to provision this infra
Terraform cli (in this use case i have used ec2 machine which has terraform cli as well as aws admin permissions)
S3 bucket to store statefiles


VPC 1 CIDR -> 10.0.0.0/21
VPC 2 CIDR -> 10.0.16.0/21
VPC 3 CIDR -> 10.0.32.0/21

Each VPC has 3 public subnets and private subnets

IT shall provision VPC with subnets along with required route-tables, internet gateway and permissions to enable VPC flow logs

Need to trigger this script thrice with three different state files for 3 VPC, to isolate the VPC's

below are the steps to execute terraform script 

1. TO PROVISION VPC 1 in us-west-2 region
2. TO PROVISION VPC 2 in us-west-2 region
3. TO PROVISION VPC 3 in us-west-2 region