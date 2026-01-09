locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

data "aws_region" "current" {}

# Security Hub
resource "aws_securityhub_account" "main" {
  enable_default_standards  = var.enable_default_standards
  auto_enable_controls      = var.auto_enable_controls
  control_finding_generator = "SECURITY_CONTROL"
}

# AWS Foundational Security Best Practices (FSBP)
resource "aws_securityhub_standards_subscription" "fsbp" {
  count = var.enable_fsbp_standard ? 1 : 0

  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/aws-foundational-security-best-practices/v/1.0.0"

  depends_on = [aws_securityhub_account.main]
}

# CIS AWS Foundations Benchmark v1.4.0
resource "aws_securityhub_standards_subscription" "cis" {
  count = var.enable_cis_standard ? 1 : 0

  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/cis-aws-foundations-benchmark/v/1.4.0"

  depends_on = [aws_securityhub_account.main]
}

# PCI DSS v3.2.1 (optional, for payment systems)
resource "aws_securityhub_standards_subscription" "pci_dss" {
  count = var.enable_pci_dss_standard ? 1 : 0

  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/pci-dss/v/3.2.1"

  depends_on = [aws_securityhub_account.main]
}

# Enable GuardDuty integration (auto-import findings)
resource "aws_securityhub_product_subscription" "guardduty" {
  product_arn = "arn:aws:securityhub:${data.aws_region.current.name}::product/aws/guardduty"

  depends_on = [aws_securityhub_account.main]
}

# Enable IAM Access Analyzer integration
resource "aws_securityhub_product_subscription" "access_analyzer" {
  product_arn = "arn:aws:securityhub:${data.aws_region.current.name}::product/aws/access-analyzer"

  depends_on = [aws_securityhub_account.main]
}

# Enable Inspector integration
resource "aws_securityhub_product_subscription" "inspector" {
  product_arn = "arn:aws:securityhub:${data.aws_region.current.name}::product/aws/inspector"

  depends_on = [aws_securityhub_account.main]
}
