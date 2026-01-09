# IAM Role for AWS Chatbot
resource "aws_iam_role" "chatbot" {
  name               = "${local.name_prefix}-chatbot-role"
  assume_role_policy = data.aws_iam_policy_document.chatbot_assume_role.json

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-chatbot-role"
  })
}

data "aws_iam_policy_document" "chatbot_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["chatbot.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Attach AWS managed policy for CloudWatch read-only access
resource "aws_iam_role_policy_attachment" "chatbot_cloudwatch" {
  role       = aws_iam_role.chatbot.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

# AWS Chatbot Configuration for Critical Alerts
resource "aws_chatbot_slack_channel_configuration" "critical" {
  configuration_name = "${local.name_prefix}-security-critical"
  iam_role_arn       = aws_iam_role.chatbot.arn
  slack_channel_id   = var.slack_channel_critical
  slack_team_id      = var.slack_workspace_id

  sns_topic_arns = [
    aws_sns_topic.critical.arn,
  ]

  guardrail_policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
  ]

  user_authorization_required = false
  logging_level               = "INFO"

  tags = merge(local.common_tags, {
    Name     = "${local.name_prefix}-security-critical-chatbot"
    Severity = "CRITICAL"
  })
}

# AWS Chatbot Configuration for High Severity Alerts
resource "aws_chatbot_slack_channel_configuration" "high" {
  configuration_name = "${local.name_prefix}-security-high"
  iam_role_arn       = aws_iam_role.chatbot.arn
  slack_channel_id   = var.slack_channel_high
  slack_team_id      = var.slack_workspace_id

  sns_topic_arns = [
    aws_sns_topic.high.arn,
  ]

  guardrail_policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
  ]

  user_authorization_required = false
  logging_level               = "INFO"

  tags = merge(local.common_tags, {
    Name     = "${local.name_prefix}-security-high-chatbot"
    Severity = "HIGH"
  })
}

# AWS Chatbot Configuration for Medium Severity Alerts
resource "aws_chatbot_slack_channel_configuration" "medium" {
  configuration_name = "${local.name_prefix}-security-medium"
  iam_role_arn       = aws_iam_role.chatbot.arn
  slack_channel_id   = var.slack_channel_medium
  slack_team_id      = var.slack_workspace_id

  sns_topic_arns = [
    aws_sns_topic.medium.arn,
  ]

  guardrail_policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
  ]

  user_authorization_required = false
  logging_level               = "INFO"

  tags = merge(local.common_tags, {
    Name     = "${local.name_prefix}-security-medium-chatbot"
    Severity = "MEDIUM"
  })
}
