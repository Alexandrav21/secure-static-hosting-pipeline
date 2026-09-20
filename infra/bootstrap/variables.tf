variable "aws_region" {
  description = "AWS region used for the Terraform state bucket."
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project name used for tagging."
  type        = string
  default     = "secure-static-site"
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  type        = string
}