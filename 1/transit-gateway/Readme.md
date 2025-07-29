Terraform script to create transit gateway with routing tabled for cross network connectivity

To provision the infra execute the below terraform commands

terraform init -backend-config="bucket=freyr-terraform-state-files-bucket" -backend-config="key=freyr/app/app.tfstate" -backend-config="region=us-west-2" -backend=true -force-copy -get=true -input=false


terraform plan -var-file=dev.tfvars -var project=freyr -var region=us-west-2 -var env=dev -out .terraform/latest-plan

Validate all the 23 resource to be created

terraform apply --input=false .terraform/latest-plan

