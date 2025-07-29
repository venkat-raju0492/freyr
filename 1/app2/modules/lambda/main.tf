locals {
  vpc_config = var.vpc_enabled ? [{
    security_group_ids = var.security_group_ids
    subnet_ids         = var.subnet_ids
  }] : []
  environment_map = var.env_vars[*]
  dead_letter_config = var.dead_letter_config_target_arn != null ? [{
    target_arn = var.dead_letter_config_target_arn
  }] : []
}

resource "aws_lambda_function" "lambda" {
  s3_bucket                      = var.s3_bucket
  s3_key                         = var.s3_key
  source_code_hash               = var.s3_key_hash
  function_name                  = var.function_name
  role                           = var.role
  handler                        = var.handler
  publish                        = var.publish
  runtime                        = var.runtime
  timeout                        = var.timeout
  memory_size                    = var.memory_size
  description                    = var.description
  reserved_concurrent_executions = var.reserved_concurrent_executions
  layers                         = var.lambda_layers

  dynamic "vpc_config" {
    for_each = local.vpc_config

    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnet_ids         = vpc_config.value.subnet_ids
    }
  }

  dynamic "environment" {
    for_each = local.environment_map
    content {
      variables = environment.value
    }
  }

  dynamic dead_letter_config {
    for_each = local.dead_letter_config
    content {
      target_arn = dead_letter_config.value.target_arn
    }
  }

  tracing_config {
    mode = var.set_xray_tracing ? "Active" : "PassThrough"
  }

  tags = merge(var.common_tags,tomap({
    Name = var.function_name
  }))

  depends_on = [var.lambda_depends_on]
}