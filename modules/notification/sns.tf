locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Module = "notification"
  }
}

# SNS Topic for Critical Security Alerts
resource "aws_sns_topic" "critical" {
  name              = "${local.name_prefix}-security-critical"
  display_name      = "Critical Security Alerts - Immediate Action Required"
  kms_master_key_id = "alias/aws/sns"

  tags = merge(local.common_tags, {
    Name     = "${local.name_prefix}-security-critical"
    Severity = "CRITICAL"
  })
}

# SNS Topic for High Severity Security Alerts
resource "aws_sns_topic" "high" {
  name              = "${local.name_prefix}-security-high"
  display_name      = "High Severity Security Alerts - Same Day Response"
  kms_master_key_id = "alias/aws/sns"

  tags = merge(local.common_tags, {
    Name     = "${local.name_prefix}-security-high"
    Severity = "HIGH"
  })
}

# SNS Topic for Medium Severity Security Alerts
resource "aws_sns_topic" "medium" {
  name              = "${local.name_prefix}-security-medium"
  display_name      = "Medium Severity Security Alerts - Weekly Review"
  kms_master_key_id = "alias/aws/sns"

  tags = merge(local.common_tags, {
    Name     = "${local.name_prefix}-security-medium"
    Severity = "MEDIUM"
  })
}

# SNS Topic Policy for Critical (allow EventBridge to publish)
data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    sid    = "AllowEventBridgePublish"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions = ["SNS:Publish"]

    resources = [
      aws_sns_topic.critical.arn,
      aws_sns_topic.high.arn,
      aws_sns_topic.medium.arn,
    ]
  }
}

resource "aws_sns_topic_policy" "critical" {
  arn    = aws_sns_topic.critical.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

resource "aws_sns_topic_policy" "high" {
  arn    = aws_sns_topic.high.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

resource "aws_sns_topic_policy" "medium" {
  arn    = aws_sns_topic.medium.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}
