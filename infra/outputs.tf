output "kms_key_arn" {
  description = "ARN of the project KMS key."
  value       = module.kms.key_arn
}

output "site_bucket_name" {
  description = "Name of the private site bucket."
  value       = module.s3.site_bucket_name
}

output "log_bucket_name" {
  description = "Name of the log bucket."
  value       = module.s3.log_bucket_name
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name."
  value       = module.cloudfront.distribution_domain_name
}