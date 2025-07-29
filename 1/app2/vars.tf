variable "region" {
  description = "AWS region where resources will be created"
  type        = string
}

variable "project" {
  description = "Name of the project"
  type        = string
}

variable "env" {
  description = "Environment (e.g., dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "vpc_endpoint_allowed_cidrs" {
  description = "CIDR blocks allowed to access the VPC endpoint"
  type        = list(string)
}

variable "retention_in_days" {
  description = "Retention period for CloudWatch logs in days"
  type        = number
  default     = 30
}

variable "lambda_s3_bucket" {
  description = "S3 bucket where the Lambda function code is stored"
  type        = string
}

variable "lambda_s3_key" {
  description = "S3 key for the Lambda function code"
  type        = string  
}

variable "lambda_handler" {
  description = "Handler for the Lambda function"
  type        = string
}

variable "lambda_runtime" {
  description = "Runtime for the Lambda function"
  type        = string
}

variable "lambda_size" {
  description = "Memory size for the Lambda function in MB"
  type        = number
}

variable "lambda_timeout" {
  description = "Timeout for the Lambda function in seconds"
  type        = number
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the VPC endpoint"
  type        = list(string)
}

variable "api_timeout" {
  description = "The timeout for the API in seconds."
  type        = number
  default = 1000
}

variable "api_throttling_burst_limit" {
  description = "Burst limit for API Gateway throttling"
  type        = number
}  

variable "api_throttling_rate_limit" {
  description = "Rate limit for API Gateway throttling"s
  type        = number
}

