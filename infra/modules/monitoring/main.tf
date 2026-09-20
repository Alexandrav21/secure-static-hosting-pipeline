resource "aws_sns_topic" "alerts" {
  name = "secure-static-site-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.sns_email
}

resource "aws_cloudwatch_metric_alarm" "cloudfront_5xx" {
  alarm_name          = "secure-static-site-cloudfront-5xx"
  alarm_description   = "Alerts when the CloudFront 5xx error rate is elevated."
  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2
  threshold          = 5

  namespace   = "AWS/CloudFront"
  metric_name = "5xxErrorRate"
  statistic   = "Average"
  period      = 300

  dimensions = {
    DistributionId = var.cloudfront_distribution_id
    Region         = "Global"
  }

  treat_missing_data = "notBreaching"

  alarm_actions = [
    aws_sns_topic.alerts.arn,
  ]
}
