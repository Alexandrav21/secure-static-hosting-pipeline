variable "cloudfront_distribution_id" {
  description = "CloudFront distribution ID to monitor."
  type        = string
}

variable "sns_email" {
  description = "Email address subscribed to monitoring alerts."
  type        = string
  sensitive   = true
}
