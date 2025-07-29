output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "public_subnets_id" {
  value = "${aws_subnet.public_subnet.*.id}"
}
output "private_subnets_id" {
  value = "${aws_subnet.private_subnet.*.id}"
}
output "log_group_arn" {
  value = aws_cloudwatch_log_group.flow_log_group.arn
}
