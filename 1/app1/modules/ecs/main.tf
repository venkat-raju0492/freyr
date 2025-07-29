locals {
  ecs_cluster_name = var.ecs_cluster_name == ""? "${var.project}-ecs-cluster-${var.env}" : var.ecs_cluster_name
  cloudwatch_logs_group = var.cloudwatch_logs_group == ""? "${var.project}-log-group-${var.env}" : var.cloudwatch_logs_group
  ecs_service_name = var.ecs_service_name == ""? var.project : var.ecs_service_name
}

data "aws_caller_identity" "current" {
}


resource "aws_ecs_cluster" "application_ecs_cluster" {
  count = var.create_ecs_cluster? 1 : 0
  name = local.ecs_cluster_name

  tags = merge(
    var.common_tags,
    {
      "Name" = local.ecs_cluster_name
    },
  )
}

resource "aws_ecs_cluster_capacity_providers" "cluster" {
  count = var.create_ecs_cluster_capacity_providers ? 1 : 0
  cluster_name = aws_ecs_cluster.application_ecs_cluster[0].name

  capacity_providers = ["FARGATE_SPOT", "FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
  }
}

resource "aws_cloudwatch_log_group" "application_log_group" {
  count             = var.create_ecs_cluster? 1 : 0
  name              = local.cloudwatch_logs_group
  retention_in_days = var.log_retention_period

  tags = merge(
    var.common_tags,
    {
      "Name" = local.cloudwatch_logs_group
    },
  )
}

resource "aws_ecs_task_definition" "application_ecs_task_definition" {
  family                   = var.ecs_task_family_name
  execution_role_arn       = var.ecs_task_role_arn
  task_role_arn            = var.ecs_task_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = [var.ecs_launch_type]
  cpu                      = var.application_cpu
  memory                   = var.application_memory
  container_definitions    = var.ecs_rendered_task_definition

  tags = merge(
    var.common_tags,
    {
      "Name" = var.ecs_task_family_name
    },
  )
}

resource "aws_ecs_service" "application_ecs_service" {
  count               = var.create_ecs_service? 1: 0
  name                = local.ecs_service_name
  cluster             = var.create_ecs_cluster? aws_ecs_cluster.application_ecs_cluster[0].id : var.ecs_cluster_id
  task_definition     = aws_ecs_task_definition.application_ecs_task_definition.arn
  desired_count       = var.ecs_service_desired_count
  ##launch_type         = var.ecs_launch_type
  scheduling_strategy = var.ecs_scheduling_strategy
  enable_execute_command = var.enable_execute_command

  dynamic "capacity_provider_strategy" {
    for_each = var.capacity_provider_strategy
    content {
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = capacity_provider_strategy.value.weight
      base              = lookup(capacity_provider_strategy.value, "base", null)
    }
  }

  network_configuration {
    security_groups  = [var.asg_security_group]
    subnets          = var.private_subnet_ids
    assign_public_ip = false
  }

  dynamic "load_balancer"{
    for_each = var.alb_target_group_arn == null ? [] : [1]
    content{
      target_group_arn = var.alb_target_group_arn
      container_name   = var.project
      container_port   = var.ecs_container_port
    }
  }

  dynamic "ordered_placement_strategy" {
    for_each = var.ecs_launch_type == "FARGATE" ? [] : [1]
    content {
      type  = "spread"
      field = "instanceId"
    }
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
  tags = merge(
    var.common_tags,
    {
      "Name" = local.ecs_cluster_name
    },
  )
  propagate_tags = var.propogate

}

resource "aws_appautoscaling_target" "application_ecs_autoscaling_target" {
  count              = var.create_ecs_service? 1: 0
  max_capacity       = var.ecs_service_max_count
  min_capacity       = var.ecs_service_min_count
  resource_id        = "service/${local.ecs_cluster_name}/${aws_ecs_service.application_ecs_service[0].name}"
  role_arn           = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "application_ecs_scaling_policy_cpu" {
  count              = var.create_ecs_cpu_scaling_policy && var.create_ecs_service? 1 : 0
  name               = "${var.ecs_task_family_name}-ecs-scaling-policy-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.application_ecs_autoscaling_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.application_ecs_autoscaling_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.application_ecs_autoscaling_target[0].service_namespace
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_in_cooldown  = var.ecs_scaleup_cooldown
    scale_out_cooldown = var.ecs_scaledown_cooldown
    disable_scale_in   = false
    target_value       = var.ecs_scale_cpu_threshold
  }
}

resource "aws_appautoscaling_policy" "application_ecs_scaling_policy_memory" {
  count              = var.create_ecs_memory_scaling_policy && var.create_ecs_service? 1 : 0
  name               = "${var.ecs_task_family_name}-ecs-scaling-memory-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.application_ecs_autoscaling_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.application_ecs_autoscaling_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.application_ecs_autoscaling_target[0].service_namespace
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    scale_in_cooldown  = var.ecs_scaleup_cooldown
    scale_out_cooldown = var.ecs_scaledown_cooldown
    disable_scale_in   = false
    target_value       = var.ecs_scale_memory_threshold
  }
}

resource "aws_appautoscaling_policy" "application_ecs_scaling_policy_request" {
  count               = var.create_ecs_alb_count_scaling_policy ? 1 : 0
  name                = "${var.ecs_task_family_name}-ecs-scaling-request-policy"
  policy_type         = "TargetTrackingScaling"
  resource_id         = aws_appautoscaling_target.application_ecs_autoscaling_target[0].resource_id
  scalable_dimension  = aws_appautoscaling_target.application_ecs_autoscaling_target[0].scalable_dimension
  service_namespace   = aws_appautoscaling_target.application_ecs_autoscaling_target[0].service_namespace
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label = var.alb_target_group_id
    }
    scale_in_cooldown = var.ecs_scaleup_cooldown
    scale_out_cooldown = var.ecs_scaledown_cooldown
    disable_scale_in = false
    target_value = var.ecs_scale_request_count_threshold
  }
}