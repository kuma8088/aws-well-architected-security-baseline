# =============================================================================
# Phase 1: Detection Services
# =============================================================================

module "guardduty" {
  source = "../../modules/guardduty"

  project_name = var.project_name
  environment  = var.environment

  # Basic detection only (no additional protection features)
  enable_s3_protection      = false
  enable_eks_protection     = false
  enable_malware_protection = false
  enable_lambda_protection  = false
  enable_rds_protection     = false

  finding_publishing_frequency = "FIFTEEN_MINUTES"
}

module "cloudtrail" {
  source = "../../modules/cloudtrail"

  project_name = var.project_name
  environment  = var.environment

  enable_log_file_validation    = true
  include_global_service_events = true
  is_multi_region_trail         = true
  log_retention_days            = 90
}

# =============================================================================
# Phase 2: Security Hub (uncomment when ready)
# =============================================================================

# module "security_hub" {
#   source = "../../modules/security-hub"
#
#   project_name = var.project_name
#   environment  = var.environment
#
#   enable_fsbp_standard = true
#   enable_cis_standard  = true
# }

# =============================================================================
# Phase 3: Notification (uncomment when ready)
# =============================================================================

# module "notification" {
#   source = "../../modules/notification"
#
#   project_name = var.project_name
#   environment  = var.environment
#
#   slack_workspace_id              = var.slack_workspace_id
#   slack_channel_security_critical = var.slack_channel_security_critical
#   slack_channel_security_high     = var.slack_channel_security_high
#   slack_channel_security_medium   = var.slack_channel_security_medium
# }
