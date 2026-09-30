output "github_actions_role_arn" {
  description = "ARN of the GitHub Actions IAM role."
  value       = aws_iam_role.github_actions.arn
}

output "terraform_plan_role_arn" {
  description = "ARN of the read-only Terraform plan role."
  value       = aws_iam_role.terraform_plan.arn
}
