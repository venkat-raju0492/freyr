output "vpc_id" {
  value = module.vpc.vpc_id
}
output "public_subnets_id" {
  value = module.vpc.public_subnets_id
}
output "private_subnets_id" {
  value = module.vpc.private_subnets_id
}
output "log_group_arn" {
  value = module.vpc.log_group_arn
}
