variable "github_owner" {
  description = "GitHub repository owner."
  type        = string
}

variable "github_repository" {
  description = "GitHub repository name."
  type        = string
}

variable "github_branch" {
  description = "GitHub branch allowed to assume the deployment role."
  type        = string
  default     = "main"
}

variable "site_bucket_arn" {
  description = "ARN of the S3 bucket containing the static site."
  type        = string
}

variable "kms_key_arn" {
  description = "ARN of the KMS key used to encrypt site objects."
  type        = string
}

variable "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution."
  type        = string
}