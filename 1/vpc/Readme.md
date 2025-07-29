Terraform script to create 3 VPC's

Prerequisites.

AWS Account with all required set of permissions to provision this infra
Terraform cli (in this use case i have used ec2 machine which has terraform cli as well as aws admin permissions)
S3 bucket to store statefiles


VPC 1 CIDR -> 10.0.0.0/20
VPC 2 CIDR -> 10.0.32.0/20
VPC 3 CIDR -> 10.0.64.0/20

Each VPC has 3 public subnets and private subnets

IT shall provision VPC with subnets along with required route-tables, internet gateway and permissions to enable VPC flow logs

Need to trigger this script thrice with three different state files for 3 VPC, to isolate the VPC's

below are the steps to execute terraform script 

1. TO PROVISION VPC 1 in us-west-2 region

terraform init -backend-config="bucket=freyr-terraform-state-files-bucket" -backend-config="key=freyr/vpc/vpc1.tfvars" -backend-config="region=us-west-2" -backend=true -force-copy -get=true -input=false

terraform plan -var-file=vpc1.tfvars -var project=vpc-a -var region=us-west-2 -var environment=dev -out .terraform/latest-plan

Validate all the plan and the 22 resources to be created

terraform apply --input=false .terraform/latest-plan


2. TO PROVISION VPC 2 in us-west-2 region
3. TO PROVISION VPC 3 in us-west-2 region