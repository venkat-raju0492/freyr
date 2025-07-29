variable "s3_bucket" {
    description = "s3_bucket"
}

variable "s3_key" {
    description = "s3_key"
}

variable "s3_key_hash" {
  description = "source code hash"
  default = null
}


variable "function_name" {
    description = "function_name"
}

variable "role" {
    description = "role"
}

variable "handler" {
    description = "handler"
}

variable "runtime" {
    description = "runtime"
}

variable "timeout" {
    description = "timeout"
    default = "15"
}

variable "memory_size" {
    description = "memory_size"
    default = "128"
}

variable "description" {
    description = "lambda description"
    default = ""
}

variable "reserved_concurrent_executions" {
  description = "reserved_concurrent_executions"
  default     = "-1"
}

variable "subnet_ids" {
  type = list(string)
  default = null
}

variable "security_group_ids" {
  type = list(string)
  default = null
}

variable "set_xray_tracing" {
    description = "set_xray_tracing"
    type = bool
    default = false
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type = map
}

variable "env_vars" {
  type    = map(string)
  default = null
}

variable "vpc_enabled" {
  default = false
  type    = bool
}

variable "lambda_layers" {
  type    = list(string)
  default = null
}

variable "lambda_depends_on" {
  default = null
}

variable "dead_letter_config_target_arn" {
  default = null
}

variable "publish" {
  default = true
}