variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "project_name" {
  description = "Project name for resource naming and tagging"
  type        = string
  default     = "security-baseline"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

# Slack notification settings (Phase 3)
variable "slack_workspace_id" {
  description = "Slack workspace ID for Chatbot"
  type        = string
  default     = ""
  sensitive   = true
}

variable "slack_channel_security_critical" {
  description = "Slack channel ID for critical security alerts"
  type        = string
  default     = ""
  sensitive   = true
}

variable "slack_channel_security_high" {
  description = "Slack channel ID for high severity security alerts"
  type        = string
  default     = ""
  sensitive   = true
}

variable "slack_channel_security_medium" {
  description = "Slack channel ID for medium severity security alerts"
  type        = string
  default     = ""
  sensitive   = true
}
