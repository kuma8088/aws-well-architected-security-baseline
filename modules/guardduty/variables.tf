variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "enable_s3_protection" {
  description = "Enable S3 protection (additional cost)"
  type        = bool
  default     = false
}

variable "enable_eks_protection" {
  description = "Enable EKS protection (additional cost)"
  type        = bool
  default     = false
}

variable "enable_malware_protection" {
  description = "Enable malware protection for EBS (additional cost)"
  type        = bool
  default     = false
}

variable "enable_lambda_protection" {
  description = "Enable Lambda protection (additional cost)"
  type        = bool
  default     = false
}

variable "enable_rds_protection" {
  description = "Enable RDS protection (additional cost)"
  type        = bool
  default     = false
}

variable "finding_publishing_frequency" {
  description = "Frequency of publishing findings (FIFTEEN_MINUTES, ONE_HOUR, SIX_HOURS)"
  type        = string
  default     = "FIFTEEN_MINUTES"

  validation {
    condition     = contains(["FIFTEEN_MINUTES", "ONE_HOUR", "SIX_HOURS"], var.finding_publishing_frequency)
    error_message = "finding_publishing_frequency must be FIFTEEN_MINUTES, ONE_HOUR, or SIX_HOURS."
  }
}
