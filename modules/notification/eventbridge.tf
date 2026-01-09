# EventBridge Rule for Critical Security Hub Findings
resource "aws_cloudwatch_event_rule" "securityhub_critical" {
  name        = "${local.name_prefix}-securityhub-critical"
  description = "Route CRITICAL severity Security Hub findings to SNS"

  event_pattern = jsonencode({
    source      = ["aws.securityhub"]
    detail-type = ["Security Hub Findings - Imported"]
    detail = {
      findings = {
        Severity = {
          Label = ["CRITICAL"]
        }
        Workflow = {
          Status = ["NEW"]
        }
      }
    }
  })

  tags = merge(local.common_tags, {
    Name     = "${local.name_prefix}-securityhub-critical"
    Severity = "CRITICAL"
  })
}

resource "aws_cloudwatch_event_target" "securityhub_critical" {
  rule      = aws_cloudwatch_event_rule.securityhub_critical.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.critical.arn

  input_transformer {
    input_paths = {
      title       = "$.detail.findings[0].Title"
      description = "$.detail.findings[0].Description"
      severity    = "$.detail.findings[0].Severity.Label"
      resource    = "$.detail.findings[0].Resources[0].Id"
      account     = "$.detail.findings[0].AwsAccountId"
      region      = "$.detail.findings[0].Region"
    }

    input_template = <<EOF
{
  "severity": "<severity>",
  "title": "<title>",
  "description": "<description>",
  "resource": "<resource>",
  "account": "<account>",
  "region": "<region>"
}
EOF
  }
}

# EventBridge Rule for High Severity Security Hub Findings
resource "aws_cloudwatch_event_rule" "securityhub_high" {
  name        = "${local.name_prefix}-securityhub-high"
  description = "Route HIGH severity Security Hub findings to SNS"

  event_pattern = jsonencode({
    source      = ["aws.securityhub"]
    detail-type = ["Security Hub Findings - Imported"]
    detail = {
      findings = {
        Severity = {
          Label = ["HIGH"]
        }
        Workflow = {
          Status = ["NEW"]
        }
      }
    }
  })

  tags = merge(local.common_tags, {
    Name     = "${local.name_prefix}-securityhub-high"
    Severity = "HIGH"
  })
}

resource "aws_cloudwatch_event_target" "securityhub_high" {
  rule      = aws_cloudwatch_event_rule.securityhub_high.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.high.arn

  input_transformer {
    input_paths = {
      title       = "$.detail.findings[0].Title"
      description = "$.detail.findings[0].Description"
      severity    = "$.detail.findings[0].Severity.Label"
      resource    = "$.detail.findings[0].Resources[0].Id"
      account     = "$.detail.findings[0].AwsAccountId"
      region      = "$.detail.findings[0].Region"
    }

    input_template = <<EOF
{
  "severity": "<severity>",
  "title": "<title>",
  "description": "<description>",
  "resource": "<resource>",
  "account": "<account>",
  "region": "<region>"
}
EOF
  }
}

# EventBridge Rule for Medium Severity Security Hub Findings
resource "aws_cloudwatch_event_rule" "securityhub_medium" {
  name        = "${local.name_prefix}-securityhub-medium"
  description = "Route MEDIUM severity Security Hub findings to SNS"

  event_pattern = jsonencode({
    source      = ["aws.securityhub"]
    detail-type = ["Security Hub Findings - Imported"]
    detail = {
      findings = {
        Severity = {
          Label = ["MEDIUM"]
        }
        Workflow = {
          Status = ["NEW"]
        }
      }
    }
  })

  tags = merge(local.common_tags, {
    Name     = "${local.name_prefix}-securityhub-medium"
    Severity = "MEDIUM"
  })
}

resource "aws_cloudwatch_event_target" "securityhub_medium" {
  rule      = aws_cloudwatch_event_rule.securityhub_medium.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.medium.arn

  input_transformer {
    input_paths = {
      title       = "$.detail.findings[0].Title"
      description = "$.detail.findings[0].Description"
      severity    = "$.detail.findings[0].Severity.Label"
      resource    = "$.detail.findings[0].Resources[0].Id"
      account     = "$.detail.findings[0].AwsAccountId"
      region      = "$.detail.findings[0].Region"
    }

    input_template = <<EOF
{
  "severity": "<severity>",
  "title": "<title>",
  "description": "<description>",
  "resource": "<resource>",
  "account": "<account>",
  "region": "<region>"
}
EOF
  }
}

# EventBridge Rule for GuardDuty Findings (direct, bypassing Security Hub delay)
resource "aws_cloudwatch_event_rule" "guardduty" {
  name        = "${local.name_prefix}-guardduty-findings"
  description = "Route GuardDuty findings directly to SNS for faster alerting"

  event_pattern = jsonencode({
    source      = ["aws.guardduty"]
    detail-type = ["GuardDuty Finding"]
    detail = {
      severity = [
        { numeric = [">=", 7.0] } # High and Critical (7.0-8.9 = High, 9.0+ = Critical)
      ]
    }
  })

  tags = merge(local.common_tags, {
    Name   = "${local.name_prefix}-guardduty-findings"
    Source = "GuardDuty"
  })
}

resource "aws_cloudwatch_event_target" "guardduty" {
  rule      = aws_cloudwatch_event_rule.guardduty.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.critical.arn

  input_transformer {
    input_paths = {
      title       = "$.detail.title"
      description = "$.detail.description"
      severity    = "$.detail.severity"
      account     = "$.detail.accountId"
      region      = "$.detail.region"
      type        = "$.detail.type"
    }

    input_template = <<EOF
{
  "source": "GuardDuty",
  "severity": "<severity>",
  "type": "<type>",
  "title": "<title>",
  "description": "<description>",
  "account": "<account>",
  "region": "<region>"
}
EOF
  }
}
