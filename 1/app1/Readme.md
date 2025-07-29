APP1 components

ECS -> Docker image with application is deployed 
      Used fargate spot for reduced cost consider this as a dev setup not recommended for prod

ECR -> Registry for docker images

IAM Role and policy -> required policy for ecs to pull docker image from ECR and print logs in log group along system manager configs to exec into docker running container
Security group -> security group for ECS as well as for vpc endpoint for whitlisting all the cidr that could access api privately

VPC Endpoint -> To enable private connectivity for REST API's
NLB -> Integration between Private API through VPC Link and ECS service
Private API Gateway -> Exposing the API privately


Prerequisites: 
Make Sure docker image is ready to be deployed

To provision the infra execute the below terraform commands

terraform init -backend-config="bucket=freyr-terraform-state-files-bucket" -backend-config="key=freyr/app1/app1.tfstate" -backend-config="region=us-west-2" -backend=true -force-copy -get=true -input=false


terraform plan -var-file=dev.tfvars -var project=freyr-aap1 -var region=us-west-2 -var env=dev -out .terraform/latest-plan