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

variable "site_bucket_name" {
  description = "Globally unique name for the private site bucket."
  type        = string
}

variable "log_bucket_name" {
  description = "Globally unique name for the CloudFront log bucket."
  type        = string
}

variable "allowed_countries" {
  description = "Countries allowed to access the CloudFront distribution."
  type        = list(string)
}