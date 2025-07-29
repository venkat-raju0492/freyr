terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.region

}

data "aws_caller_identity" "current" {}

locals {
  cloudwatch_logs_group               = "/aws/lambda/${var.project}/${var.env}"

  # Common tags to be assigned to all resources
  common_tags = {
    Project      = var.project
    Environment  = var.env
    CreatedBy    = "Terraform"
    CostCategory = "freyr"
  }

  account_id = data.aws_caller_identity.current.account_id
}

data "template_file" "private_api_swagger" {
  template = file("./templates/private-api.json")
  
  vars = {
    project                       = var.project
    env                           = var.env
    integration_lambda_invoke_arn = module.lambda.lambda_function_invoke_arn
    API_TIMEOUT                   = var.api_timeout
    vpc_endpoint                  = module.vpc-endpoint.vpc_endpoint_id
  }
}

module "security" {
  source                     = "./modules/security"
  project                    = var.project
  env                        = var.env
  vpc_id                     = var.vpc_id
  vpc_endpoint_allowed_cidrs = var.vpc_endpoint_allowed_cidrs
  common_tags                = local.common_tags
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = local.cloudwatch_logs_group
  retention_in_days = var.retention_in_days
  tags              = local.common_tags
}

module "lambda" {
  source                        = "./modules/lambda/"
  s3_bucket                     = var.lambda_s3_bucket
  s3_key                        = var.lambda_s3_key
  function_name                 = "${var.project}-${var.env}"
  role                          = module.security.lambda_role_arn
  handler                       = var.lambda_handler
  runtime                       = var.lambda_runtime
  timeout                       = var.lambda_timeout
  memory_size                   = var.lambda_size
  vpc_enabled                   = false

  env_vars = {
    env                         = var.env
    lambda_function_name        = "${var.project}-${var.env}"
  }

  depends_on = [aws_cloudwatch_log_group.lambda_log_group]

  common_tags = merge(local.common_tags, tomap({
                    deploy_version = var.lambda_s3_key
  }))
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

module "Private-API" {
  source                       = "./modules/private-api-gateway"
  project                      = "${var.project}"
  env                          = var.env
  api_swagger_config           = data.template_file.private_api_swagger.rendered
  vpc_endpoint_id              = module.vpc-endpoint.vpc_endpoint_id
  common_tags                  = local.common_tags
  api_throttling_burst_limit   = var.api_throttling_burst_limit
  api_throttling_rate_limit    = var.api_throttling_rate_limit
  region                       = var.region
}

resource "aws_lambda_permission" "eom_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${module.Private-API.api_arn}/*/*"
}