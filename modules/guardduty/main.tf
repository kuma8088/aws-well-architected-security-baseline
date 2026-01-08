locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# GuardDuty Detector
resource "aws_guardduty_detector" "main" {
  enable                       = true
  finding_publishing_frequency = var.finding_publishing_frequency

  datasources {
    s3_logs {
      enable = var.enable_s3_protection
    }

    kubernetes {
      audit_logs {
        enable = var.enable_eks_protection
      }
    }

    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = var.enable_malware_protection
        }
      }
    }
  }

  tags = {
    Name = "${local.name_prefix}-guardduty"
  }
}

# Lambda Protection (separate resource in newer AWS provider)
resource "aws_guardduty_detector_feature" "lambda" {
  count = var.enable_lambda_protection ? 1 : 0

  detector_id = aws_guardduty_detector.main.id
  name        = "LAMBDA_NETWORK_LOGS"
  status      = "ENABLED"
}

# RDS Protection (separate resource in newer AWS provider)
resource "aws_guardduty_detector_feature" "rds" {
  count = var.enable_rds_protection ? 1 : 0

  detector_id = aws_guardduty_detector.main.id
  name        = "RDS_LOGIN_EVENTS"
  status      = "ENABLED"
}
