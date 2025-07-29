variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}

variable "env" {
  description = "The name of the environment"
}

variable "project" {
  description = "The name of the project"
}

variable "ecs_cluster_name" {
  description = "ECS Cluster name"
  default = ""
}

variable "asg_security_group" {
  description = "ASG Security Group"
  default = null
}

variable "ecs_task_role_arn" {
  description = "ECS Task Role ARN"
}

variable "ecs_task_family_name" {
  description = "ECS task definition family name"
}

variable "ecs_service_desired_count" {
  description = "ECS service desired count"
  default     = "2"
}

variable "ecs_service_max_count" {
  description = "ECS service max count"
  default     = "10"
}

variable "ecs_service_min_count" {
  description = "ECS service min count"
  default     = "1"
}

variable "ecs_launch_type" {
  description = "ECS launch type (ex: FARGATE)"
}

variable "ecs_container_port" {
  description = "Container port"
  default     = "80"
}

variable "ecs_rendered_task_definition" {
  description = "Rendered task definition for container"
}

variable "ecs_scaleup_cooldown" {
  description = "ECS scale in cool down period"
  default     = 300
}

variable "ecs_scaledown_cooldown" {
  description = "ECS scale out cool down period"
  default     = 300
}

variable "ecs_scale_cpu_threshold" {
  description = "CPU percentage threshold to scale"
  default     = 60
}

variable "ecs_scale_memory_threshold" {
  description = "Memory percentage threshold to scale"
  default     = 85
}

variable "ecs_scale_request_count_threshold" {
  description = "ALB request threshold to scale"
  default     = 30.0
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnets"
  default = null
}

variable "alb_target_group_arn" {
  description = "arn of the ALB target group"
  default = null
}



variable "application_cpu" {
  description = "Application instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "512"
}

variable "application_memory" {
  description = "Application instance memory to provision (in MiB)"
  default     = "512"
}

variable "ecs_scheduling_strategy" {
  description = "The scheduling strategy to use for the service"
  default     = "REPLICA"
}

variable "cloudwatch_logs_group" {
  description = "CloudWatch logs group name"
  default = ""
}

variable "alb_target_group_id" {
  description = "resource identifier for scaling group"
  default = null
}

variable "create_ecs_cluster" {
  description = "OPTIONAL: Create ecs cluster"
  type = bool
  default = true
}

variable "create_ecs_service" {
  description = "OPTIONAL: Create ecs service"
  type = bool
  default = true
}

variable "ecs_cluster_id" {
  description = "OPTIONAL: ECS cluster id"
  default = null
}

variable "ecs_service_name" {
  description = "ecs service name"
  default = ""
}

variable "create_ecs_cpu_scaling_policy" {
  description = "OPTIONAL: Create ecs cpu scaling policy"
  type = bool
  default = true
}

variable "create_ecs_memory_scaling_policy" {
  description = "OPTIONAL: Create ecs memory scaling policy"
  type = bool
  default = true
}

variable "create_ecs_alb_count_scaling_policy" {
  description = "OPTIONAL: Create ecs ALB count scaling policy"
  type = bool
  default = true
}

variable "log_retention_period" {
  description = "OPTIONAL: Log retention period in days"
  default = "30"
}

variable "propogate" {
  default = "SERVICE"
  description = "propogate"
} 

variable "capacity_provider_strategy" {
  type        = list(any)
  description = "(Optional) The capacity_provider_strategy configuration block. This is a list of maps, where each map should contain \"capacity_provider \", \"weight\" and \"base\""
  default     = []
}

variable "create_ecs_cluster_capacity_providers" {
  description = "whether to create exs cluster capacity provider"
  default = false
}

variable "enable_execute_command" {
  description = "enable execute command"
  default = false
}