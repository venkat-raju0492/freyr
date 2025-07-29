variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}

variable "env" {
  description = "The name of the environment"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnets ids"
}

variable "alb_targetgroup_port" {
  description = "Target group port"
}

variable "alb_targetgroup_protocol" {
  description = "Target group port"
  default     = "TCP"
}

variable "alb_targetgroup_healthcheck_protocol" {
  description = "Target group health check port"
  default     = "HTTP"
}

variable "alb_targetgroup_target_type" {
  description = "Target group target_type"
  default     = "instance"
}

variable "alb_internal" {
  description = "Is it internal ALB?"
  default     = false
}

variable "alb_healthy_threshold" {
  description = "default threshold"
  default     = 3
}

variable "alb_health_interval" {
  description = "default interval between checks"
  default     = 30
}

variable "alb_unhealthy_threshold" {
  description = "default un health threshold"
  default     = 2
}

variable "alb_health_check_port" {
  description = "custom port to use instead of default value traffic port. set null for modules which use default traffic port"
  default     = null
}

variable "idle_timeout" {
  description = "Idle timeout"
  default = "300"
}

variable "enable_deletion_protection" {
  description = "Enable delete protection"
  default = true
}

variable "lb_prefix" {
  description = "lb prefix name"
}

variable "health_check_path" {
  description = "health check path"
  default = "/actuator/health"
}

variable "alb_health_timeout" {
  description = "default interval between checks"
  default     = 3
}

variable "alb_healthy_status_code" {
  description  = "alb healthy status code"
  default = "200"
}

variable "nlb_enable_cross_zone_load_balancing" {
  description = "nlb enable cross zone load balancing"
}