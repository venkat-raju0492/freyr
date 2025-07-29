
resource "aws_api_gateway_rest_api" "api" {
 name                     = "${var.project}-api-${var.env}"
 description              = "${var.project}-api-${var.env} rest api"
 body                     = var.api_swagger_config
 endpoint_configuration {
   types            = ["PRIVATE"]
   vpc_endpoint_ids = [var.vpc_endpoint_id]
 }
 tags = merge(
    var.common_tags,
    {
      "Name" = "${var.project}-api-${var.env}"
    },
 )
}

resource "aws_api_gateway_deployment" "deploy_api" {
  depends_on = [aws_api_gateway_rest_api.api]

  rest_api_id = aws_api_gateway_rest_api.api.id

  variables = {
    deployed_at = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api_stage" {
  stage_name    = var.env
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.deploy_api.id

  variables = {
    deployed_at = timestamp()
  }

  tags = merge(
    var.common_tags,
    {
      "Name" = var.env
    },
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_method_settings" "api_settings" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = aws_api_gateway_stage.api_stage.stage_name
  method_path = "*/*"
  settings {
    logging_level          = var.logging_level
    data_trace_enabled     = true
    metrics_enabled        = true
    throttling_burst_limit = var.api_throttling_burst_limit
    throttling_rate_limit  = var.api_throttling_rate_limit
  }
}