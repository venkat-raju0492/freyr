resource "aws_alb_target_group" "alb-tg" {
  name                 = "${var.lb_prefix}-tg-${var.env}"
  port                 = var.alb_targetgroup_port
  protocol             = var.alb_targetgroup_protocol
  vpc_id               = var.vpc_id
  target_type          = var.alb_targetgroup_target_type

  health_check {
    healthy_threshold   = var.alb_healthy_threshold
    interval            = var.alb_health_interval
    protocol            = var.alb_targetgroup_healthcheck_protocol
    matcher             = var.alb_healthy_status_code
    timeout             = var.alb_health_timeout
    path                = var.health_check_path
    unhealthy_threshold = var.alb_unhealthy_threshold
    port                = var.alb_health_check_port
  }

  tags = merge(
    var.common_tags,
    {
      "Name" = "${var.lb_prefix}-tg-${var.env}"
    },
  )

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_alb.alb]
}

resource "aws_alb" "alb" {
  name            = "${var.lb_prefix}-lb-${var.env}"
  subnets         = var.subnet_ids
  idle_timeout    = var.idle_timeout
  internal        = var.alb_internal
  load_balancer_type               = "network"
  enable_deletion_protection       = var.enable_deletion_protection
  enable_cross_zone_load_balancing = var.nlb_enable_cross_zone_load_balancing

  tags = merge(
    var.common_tags,
    {
      "Name" = "${var.lb_prefix}-lb-${var.env}"
    },
  )
}

resource "aws_lb_listener" "alb-listener-http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alb-tg.arn
  }
}

resource "aws_lb_listener" "alb-listener-https" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.alb-tg.arn
  }
}