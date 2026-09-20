variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key ARN used for S3 encryption."
  type        = string
}

variable "site_bucket_name" {
  description = "Name of the private site bucket."
  type        = string
}

variable "log_bucket_name" {
  description = "Name of the CloudFront log bucket."
  type        = string
}