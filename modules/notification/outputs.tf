output "critical_topic_arn" {
  description = "ARN of the critical security alerts SNS topic"
  value       = aws_sns_topic.critical.arn
}

output "high_topic_arn" {
  description = "ARN of the high severity security alerts SNS topic"
  value       = aws_sns_topic.high.arn
}

output "medium_topic_arn" {
  description = "ARN of the medium severity security alerts SNS topic"
  value       = aws_sns_topic.medium.arn
}

output "chatbot_critical_arn" {
  description = "ARN of the critical Chatbot configuration"
  value       = aws_chatbot_slack_channel_configuration.critical.chat_configuration_arn
}

output "chatbot_high_arn" {
  description = "ARN of the high severity Chatbot configuration"
  value       = aws_chatbot_slack_channel_configuration.high.chat_configuration_arn
}

output "chatbot_medium_arn" {
  description = "ARN of the medium severity Chatbot configuration"
  value       = aws_chatbot_slack_channel_configuration.medium.chat_configuration_arn
}

output "eventbridge_rule_securityhub_critical_arn" {
  description = "ARN of the Security Hub critical EventBridge rule"
  value       = aws_cloudwatch_event_rule.securityhub_critical.arn
}

output "eventbridge_rule_guardduty_arn" {
  description = "ARN of the GuardDuty EventBridge rule"
  value       = aws_cloudwatch_event_rule.guardduty.arn
}
