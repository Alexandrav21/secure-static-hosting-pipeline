variable "aws_region" {
  description = "AWS region for regional resources."
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project name used for tagging and naming."
  type        = string
  default     = "secure-static-site"
}