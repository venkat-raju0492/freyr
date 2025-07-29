terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.region

}

data "aws_caller_identity" "current" {}

locals {
  ecs_cluster_name                              = "${var.project}-${var.env}"
  cloudwatch_container_logs_group               = "/ecs/${var.project}/${var.env}"
  ecs_task_family_name                          = "${var.project}-${var.env}"
  lb_endpoint                                   = "${var.project}-${var.env}.freyr.com"

  # Common tags to be assigned to all resources
  common_tags = {
    Project      = var.project
    Environment  = var.env
    CreatedBy    = "Terraform"
    CostCategory = "freyr"
  }

  account_id = data.aws_caller_identity.current.account_id
}

data "template_file" "ecs_task_api" {
  template = file(".templates/ecs/task-definition.json")

  vars = {
     project                = var.project
     env                    = var.env
     aws_account_id         = data.aws_caller_identity.current.account_id
     region                 = var.region
     ecr_repo               = module.ECR.registry_id
     image_tag              = var.image_tag
     application_memory     = var.application_memory
     application_cpu        = var.application_cpu
     ecs_container_port     = var.ecs_container_port
     cloudwatch_logs_group  = local.cloudwatch_container_logs_group
  }
}

data "template_file" "private_api_swagger" {
  template = file(".templates/apigateway/private-api.json")
  
  vars = {
    project               = var.project
    env                   = var.env
    vpc_link_id           = module.Private-API.vpc_link_id
    lb_endpoint           = local.lb_endpoint
    API_TIMEOUT           = var.api_timeout
    vpc_endpoint          = module.vpc-endpoint.vpc_endpoint_id
  }
}

module "security" {
  source                     = "./modules/security"
  project                    = var.project
  env                        = var.env
  vpc_id                     = var.vpc_id
  vpc_endpoint_allowed_cidrs = var.vpc_endpoint_allowed_cidrs
  common_tags                = local.common_tags
  ecs_allowed_cidr           = var.ecs_allowed_cidr
  ecs_container_port         = var.ecs_container_port
}

module "ECR" {
  source      = "./modules/ecr"
  project     = var.project
  common_tags = local.common_tags
}

module "vpc-endpoint" {
  source                     = "./modules/vpc-endpoint"
  vpc_id                     = var.vpc_id
  region                     = var.region
  vpc_endpoint_sg_id         = module.security.vpc_endpoint_sg_id
  private_subnet_ids         = var.private_subnet_ids
  common_tags                = local.common_tags
  project                    = var.project
  env                        = var.env
}

module "network-lb-api" {
  source                      = "./modules/nlb"
  subnet_ids                  = var.private_subnet_ids
  vpc_id                      = var.vpc_id
  env                         = var.env
  common_tags                 = local.common_tags
  alb_targetgroup_target_type = "ip"
  alb_health_check_port       = var.ecs_container_port
  alb_targetgroup_port        = var.ecs_container_port
  alb_internal                = "true"
  alb_unhealthy_threshold     = var.alb_unhealthy_threshold
  health_check_path           = var.health_check_path
  lb_prefix                   = "${var.project}-ntwk"
  alb_health_timeout          = var.alb_health_timeout
  nlb_enable_cross_zone_load_balancing = var.nlb_enable_cross_zone_load_balancing
}

module "Private-API" {
  source                       = "./modules/private-api-gateway"
  project                      = "${var.project}-ngs"
  env                          = var.env
  lb_target_arn                = module.network-lb-api.lb_arn
  api_swagger_config           = data.template_file.private_api_swagger.rendered
  vpc_endpoint_id              = module.vpc-endpoint.vpc_endpoint_id
  common_tags                  = local.common_tags
  api_throttling_burst_limit   = var.api_throttling_burst_limit
  api_throttling_rate_limit    = var.api_throttling_rate_limit
  region                       = var.region
}

module "ecs" {
  source                           = "./modules/ecs/"
  project                          = "${var.project}"
  env                              = var.env
  create_ecs_cluster               = true // Create, ecs cluster Default: true
  ecs_cluster_name                 = local.ecs_cluster_name
  cloudwatch_logs_group            = local.cloudwatch_container_logs_group
  ecs_launch_type                  = var.ecs_launch_type
  ecs_task_family_name             = local.ecs_task_family_name
  private_subnet_ids               = var.private_subnet_ids
  application_cpu                  = var.application_cpu
  application_memory               = var.application_memory
  ecs_service_min_count            = var.ecs_service_min_count
  ecs_service_max_count            = var.ecs_service_max_count
  ecs_service_desired_count        = var.ecs_service_desired_count
  ecs_rendered_task_definition     = data.template_file.ecs_task_api.rendered
  common_tags                      = local.common_tags
  asg_security_group               = module.Security.asg-sg-api-id
  ecs_task_role_arn                = module.Security.ecs-task-role-arn
  alb_target_group_arn             = 
  ecs_container_port               = var.ecs_container_port
  create_ecs_memory_scaling_policy = var.create_ecs_memory_scaling_policy
  capacity_provider_strategy       = var.capacity_provider_strategy
  create_ecs_alb_count_scaling_policy   = var.create_ecs_alb_count_scaling_policy
  create_ecs_cluster_capacity_providers = true
  enable_execute_command = true
  log_retention_period = var.log_retention_period
}