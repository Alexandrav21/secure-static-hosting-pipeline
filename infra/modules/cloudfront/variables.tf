variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
}

variable "site_bucket_arn" {
  description = "ARN of the private S3 site bucket."
  type        = string
}

variable "site_bucket_regional_domain_name" {
  description = "Regional domain name of the private S3 site bucket."
  type        = string
}