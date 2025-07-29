terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

locals {
  lambda1_log_group_name = "/aws/lambda/${var.project}1-${var.env}"
  lambda2_log_group_name = "/aws/lambda/${var.project}2-${var.env}"
  lambda3_log_group_name = "/aws/lambda/${var.project}3-${var.env}"

  # Common tags to be assigned to all resources
  common_tags = {
    Project      = var.project
    Environment  = var.env
    CreatedBy    = "Terraform"
    CostCategory = "freyr"
  }

  account_id = data.aws_caller_identity.current.account_id
}

module "security" {
  source                     = "./modules/security"
  project                    = var.project
  env                        = var.env
  common_tags                = local.common_tags
}

resource "aws_cloudwatch_log_group" "lambda1_log_group" {
  name              = local.lambda1_log_group_name
  retention_in_days = var.retention_in_days
  tags              = local.common_tags
}

resource "aws_cloudwatch_log_group" "lambda2_log_group" {
  name              = local.lambda2_log_group_name
  retention_in_days = var.retention_in_days
  tags              = local.common_tags
}

resource "aws_cloudwatch_log_group" "lambda3_log_group" {
  name              = local.lambda3_log_group_name
  retention_in_days = var.retention_in_days
  tags              = local.common_tags
}

module "lambda1" {
  source                        = "./modules/lambda/"
  s3_bucket                     = var.lambda_s3_bucket
  s3_key                        = var.lambda_s3_key1
  function_name                 = "${var.project}1-${var.env}"
  role                          = module.security.lambda_role_arn
  handler                       = var.lambda_handler1
  runtime                       = var.lambda_runtime
  timeout                       = var.lambda_timeout
  memory_size                   = var.lambda_size
  vpc_enabled                   = false

  env_vars = {
    env                         = var.env
    lambda_function_name        = "${var.project}1-${var.env}"
    LAMBDA_2_ARN                = module.lambda2.lambda_function_arn
  }

  depends_on = [aws_cloudwatch_log_group.lambda1_log_group]

  common_tags = merge(local.common_tags, tomap({
                    deploy_version = var.lambda_s3_key1
  }))
}

module "lambda2" {
  source                        = "./modules/lambda/"
  s3_bucket                     = var.lambda_s3_bucket
  s3_key                        = var.lambda_s3_key2
  function_name                 = "${var.project}2-${var.env}"
  role                          = module.security.lambda_role_arn
  handler                       = var.lambda_handler2
  runtime                       = var.lambda_runtime
  timeout                       = var.lambda_timeout
  memory_size                   = var.lambda_size
  vpc_enabled                   = false

  env_vars = {
    env                         = var.env
    lambda_function_name        = "${var.project}2-${var.env}"
    LAMBDA_2_ARN                = module.lambda3.lambda_function_arn
  }

  depends_on = [aws_cloudwatch_log_group.lambda2_log_group]

  common_tags = merge(local.common_tags, tomap({
                    deploy_version = var.lambda_s3_key2
  }))
}

module "lambda3" {
  source                        = "./modules/lambda/"
  s3_bucket                     = var.lambda_s3_bucket
  s3_key                        = var.lambda_s3_key3
  function_name                 = "${var.project}3-${var.env}"
  role                          = module.security.lambda_role_arn
  handler                       = var.lambda_handler3
  runtime                       = var.lambda_runtime
  timeout                       = var.lambda_timeout
  memory_size                   = var.lambda_size
  vpc_enabled                   = false

  env_vars = {
    env                         = var.env
    lambda_function_name        = "${var.project}-${var.env}"
  }

  depends_on = [aws_cloudwatch_log_group.lambda3_log_group]

  common_tags = merge(local.common_tags, tomap({
                    deploy_version = var.lambda_s3_key3
  }))
}