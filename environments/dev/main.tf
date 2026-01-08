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
# Phase 2: Security Hub
# =============================================================================

module "security_hub" {
  source = "../../modules/security-hub"

  project_name = var.project_name
  environment  = var.environment

  # Security standards
  enable_fsbp_standard    = true  # AWS Foundational Security Best Practices
  enable_cis_standard     = true  # CIS AWS Foundations Benchmark v1.4.0
  enable_pci_dss_standard = false # PCI DSS (payment systems only)

  # Auto-enable new controls when added
  auto_enable_controls     = true
  enable_default_standards = false
}

# =============================================================================
# Phase 3: Notification
# =============================================================================

module "notification" {
  source = "../../modules/notification"

  project_name = var.project_name
  environment  = var.environment

  # Slack configuration
  slack_workspace_id     = var.slack_workspace_id
  slack_channel_critical = var.slack_channel_security_critical
  slack_channel_high     = var.slack_channel_security_high
  slack_channel_medium   = var.slack_channel_security_medium
}
