output "site_bucket_name" {
  description = "Name of the private site bucket."
  value       = aws_s3_bucket.site.id
}

output "site_bucket_arn" {
  description = "ARN of the private site bucket."
  value       = aws_s3_bucket.site.arn
}

output "site_bucket_regional_domain_name" {
  description = "Regional domain name of the site bucket."
  value       = aws_s3_bucket.site.bucket_regional_domain_name
}

output "log_bucket_name" {
  description = "Name of the log bucket."
  value       = aws_s3_bucket.logs.id
}

output "log_bucket_arn" {
  description = "ARN of the log bucket."
  value       = aws_s3_bucket.logs.arn
}