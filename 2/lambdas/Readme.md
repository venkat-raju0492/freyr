Prerequisites
all the 3 apps with python code to be zipped and uploaded to s3

Terraform script to create 3 lambdas

Lambda 1 triggers with on demand with some payload

same payload is passed to lambda2 amnd triggers lambda2

lambda2 get invoked from lambda1 and get the payload and it passes it to lambda3

lambda3 get invoked from lambda2 and prints the payload

To provision the infra execute the commands below

terraform init -backend-config="bucket=freyr-terraform-state-files-bucket" -backend-config="key=freyr/2/freyr-app.tfstate" -backend-config="region=us-west-2" -backend=true -force-copy -get=true -input=false


terraform plan -var-file=dev.tfvars -var project=freyr-app -var region=us-west-2 -var env=dev -out .terraform/latest-plan

terraform apply --input=false .terraform/latest-plan