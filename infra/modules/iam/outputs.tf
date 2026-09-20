output "github_actions_role_arn" {
  description = "ARN of the GitHub Actions IAM role."
  value       = aws_iam_role.github_actions.arn
}