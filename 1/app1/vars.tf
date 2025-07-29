variable "region" {
  description = "The AWS region where the resources will be created."
  type        = string
  default     = "us-west-2"  
}

variable "project" {
  description = "The name of the project."
  type        = string
}

variable "env" {
  description = "The environment (e.g., dev, staging, prod)."
  type        = string
}

variable "image_tag" {
  description = "The tag for the Docker image."
  type        = string
}

variable "application_memory" {
  description = "The amount of memory (in MiB) allocated to the application."
  type        = number
}

variable "application_cpu" {
  description = "The amount of CPU (in units) allocated to the application."
  type        = number
}

variable "ecs_container_port" {
  description = "The port on which the ECS container will listen."
  type        = number
}

variable "api_timeout" {
  description = "The timeout for the API in seconds."
  type        = number
  default = 1000
}

variable "vpc_id" {
  description = "The ID of the VPC where resources will be deployed."
  type        = string
}


variable "vpc_endpoint_allowed_cidrs" {
  description = "List of CIDRs allowed to access the VPC endpoint."
  type        = list(string)
  default     = []
}

variable "ecs_allowed_cidr" {
  description = "CIDR allowed to access ECS resources."
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs where the ECS tasks will run."
  type        = list(string)
}

variable "alb_unhealthy_threshold" {
  description = "value for ALB unhealthy threshold."
  default     = 3
}

variable "health_check_path" {
  description = "The path for the health check."
  type        = string
  default     = "/actuator/health"
}

variable "alb_health_timeout" {
  description = "The timeout for the ALB health check in seconds."
  type        = number
  default     = 2
}

variable "nlb_enable_cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing for the NLB."
  type        = bool
  default     = true
}

variable "api_throttling_burst_limit" {
  description = "Burst limit for API throttling."
  type        = number
}

variable "api_throttling_rate_limit" {
  description = "Rate limit for API throttling in requests per second."
  type        = number
}

variable "ecs_launch_type" {
  description = "value for ECS launch type."
}

variable "ecs_service_min_count" {
  description = "Minimum number of ECS service instances."
  type        = number
}

variable "ecs_service_max_count" {
  description = "Maximum number of ECS service instances."
  type        = number
}

variable "ecs_service_desired_count" {
  description = "Desired number of ECS service instances."
  type        = number
}

variable "create_ecs_memory_scaling_policy" {
  description = "Flag to create ECS memory scaling policy."
  type        = bool 
  default     = true
}

variable "capacity_provider_strategy" {
  description = "value for ECS capacity provider strategy."
  default     = []
}

variable "create_ecs_alb_count_scaling_policy" {
  description = "value for creating ECS ALB count scaling policy."
  default     = false
}

variable "log_retention_period" {
  description = "The retention period for CloudWatch logs in days."
  type        = number
  default     = 30
}