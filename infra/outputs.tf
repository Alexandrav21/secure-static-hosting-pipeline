output "kms_key_arn" {
  description = "ARN of the project KMS key."
  value       = module.kms.key_arn
}