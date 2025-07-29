output "alb_target_group_id" {
    value = "${aws_alb.alb.arn_suffix}/${aws_alb_target_group.alb-tg.arn_suffix}"
}

output "alb_target_group_arn" {
    value = aws_alb_target_group.alb-tg.arn
}

output "lb_endpoint" {
    value = aws_alb.alb.dns_name
}

output "lb_arn" {
    value = aws_alb.alb.arn
}