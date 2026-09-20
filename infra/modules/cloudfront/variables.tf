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

variable "allowed_countries" {
  description = "ISO 3166-1 alpha-2 country codes allowed to access the distribution."
  type        = list(string)
}

variable "domain_name" {
  description = "Custom domain name for the CloudFront distribution."
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN for the CloudFront distribution."
  type        = string
}
