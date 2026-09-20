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

variable "github_owner" {
  description = "GitHub repository owner."
  type        = string
}

variable "github_repository" {
  description = "GitHub repository name."
  type        = string
}

variable "sns_email" {
  description = "Email address used for monitoring notifications."
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "Custom domain name for the site."
  type        = string
}

variable "hosted_zone_id" {
  description = "Route 53 hosted zone ID."
  type        = string
}
