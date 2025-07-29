variable "region" {
  description = "AWS region where resources will be created"
  type        = string
}

variable "project" {
  description = "Project name for resource tagging"
  type        = string
}

variable "env" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "retention_in_days" {
  description = "Retention period for CloudWatch log groups in days"
  type        = number
  default     = 30
}

variable "lambda_s3_bucket" {
  description = "S3 bucket where Lambda code is stored"
  type        = string
}

variable "lambda_s3_key1" {
  description = "S3 key for the first Lambda function code"
  type        = string
}

variable "lambda_s3_key2" {
  description = "S3 key for the second Lambda function code"
  type        = string
}

variable "lambda_s3_key3" {
  description = "S3 key for the third Lambda function code"
  type        = string
}   

variable "lambda_handler1" {
  description = "Handler for the 1st Lambda functions"
  type        = string
}

variable "lambda_handler2" {
  description = "Handler for the 2nd Lambda functions"
  type        = string
}

variable "lambda_handler3" {
  description = "Handler for the 3rd Lambda functions"
  type        = string
}

variable "lambda_runtime" {
  description = "Runtime for the Lambda functions (e.g., nodejs14.x, python3.8)"
  type        = string
}

variable "lambda_timeout" {
  description = "Timeout for the Lambda functions in seconds"
  type        = number
  default     = 900
}

variable "lambda_size" {
  description = "Memory size for the Lambda functions in MB"
  type        = number
  default     = 128
}