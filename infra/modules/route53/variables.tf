variable "domain_name" {
  description = "Domain name pointing to CloudFront."
  type        = string
}

variable "hosted_zone_id" {
  description = "Route 53 hosted zone ID."
  type        = string
}

variable "cloudfront_domain_name" {
  description = "CloudFront distribution domain name."
  type        = string
}

variable "cloudfront_hosted_zone_id" {
  description = "CloudFront hosted zone ID."
  type        = string
}
