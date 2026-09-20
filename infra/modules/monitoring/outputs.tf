output "sns_topic_arn" {
  description = "SNS topic used for monitoring alerts."
  value       = aws_sns_topic.alerts.arn
}
