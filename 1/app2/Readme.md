APP1 components

Lambda -> python code that runs to print hello world


IAM Role and policy -> required policy for lambda to put logs and invode functions
Security group -> security group for vpc endpoint for whitlisting all the cidr that could access api privately

VPC Endpoint -> To enable private connectivity for REST API's
Private API Gateway -> Exposing the API privately


Prerequisites: 
Make Sure python code is zipped and uploaded to s3 bucket

To provision the infra execute the below terraform commands

terraform init -backend-config="bucket=freyr-terraform-state-files-bucket" -backend-config="key=freyr/app2/app2.tfstate" -backend-config="region=us-west-2" -backend=true -force-copy -get=true -input=false


terraform plan -var-file=dev.tfvars -var project=freyr-aap1 -var region=us-west-2 -var env=dev -out .terraform/latest-plan

Validate all the 23 resource to be created

terraform apply --input=false .terraform/latest-plan