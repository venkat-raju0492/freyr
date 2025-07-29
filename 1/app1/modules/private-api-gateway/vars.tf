variable "project" {
    description = "name of the project"
}

variable "env" {
    description = "name of the environment"
}

variable "lb_target_arn" {
    description = "lb target arn"
}

variable "api_swagger_config" {
    description = "api swagger config"
}

variable "vpc_endpoint_id" {
    description = "vpc endpoint id"
}

variable "common_tags" {
    description = "common tags"
}

variable "logging_level" {
    description = "logging level"
    default = "INFO"
}

variable "api_throttling_rate_limit" {
    description = "api throttling rate limit"
} 

variable "api_throttling_burst_limit" {
    description = "api throttling burst limit"
}

variable "region" {
  description = "value of the region"
}