variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "slack_workspace_id" {
  description = "Slack workspace ID"
  type        = string
  sensitive   = true
}

variable "slack_channel_critical" {
  description = "Slack channel ID for critical security alerts"
  type        = string
  sensitive   = true
}

variable "slack_channel_high" {
  description = "Slack channel ID for high severity security alerts"
  type        = string
  sensitive   = true
}

variable "slack_channel_medium" {
  description = "Slack channel ID for medium severity security alerts"
  type        = string
  sensitive   = true
}
