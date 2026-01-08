output "guardduty_detector_id" {
  description = "GuardDuty detector ID"
  value       = module.guardduty.detector_id
}

output "cloudtrail_arn" {
  description = "CloudTrail trail ARN"
  value       = module.cloudtrail.trail_arn
}

output "cloudtrail_s3_bucket_name" {
  description = "S3 bucket name for CloudTrail logs"
  value       = module.cloudtrail.s3_bucket_name
}

output "securityhub_account_id" {
  description = "Security Hub account ID"
  value       = module.security_hub.securityhub_account_id
}

output "sns_topic_critical_arn" {
  description = "ARN of the critical security alerts SNS topic"
  value       = module.notification.critical_topic_arn
}

output "sns_topic_high_arn" {
  description = "ARN of the high severity security alerts SNS topic"
  value       = module.notification.high_topic_arn
}
