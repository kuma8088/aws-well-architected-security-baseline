output "securityhub_account_id" {
  description = "Security Hub account ID"
  value       = aws_securityhub_account.main.id
}

output "fsbp_subscription_arn" {
  description = "FSBP standards subscription ARN"
  value       = var.enable_fsbp_standard ? aws_securityhub_standards_subscription.fsbp[0].id : null
}

output "cis_subscription_arn" {
  description = "CIS standards subscription ARN"
  value       = var.enable_cis_standard ? aws_securityhub_standards_subscription.cis[0].id : null
}
