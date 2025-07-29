variable "project" {
  description = "name of the project"
  type        = string
}

variable "common_tags" {
  description = "values to be used as tags for all resources"
  type        = map(string)
}