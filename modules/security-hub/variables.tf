variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "enable_fsbp_standard" {
  description = "Enable AWS Foundational Security Best Practices standard"
  type        = bool
  default     = true
}

variable "enable_cis_standard" {
  description = "Enable CIS AWS Foundations Benchmark standard"
  type        = bool
  default     = true
}

variable "enable_pci_dss_standard" {
  description = "Enable PCI DSS standard (for payment systems)"
  type        = bool
  default     = false
}

variable "auto_enable_controls" {
  description = "Automatically enable new controls when they are added to standards"
  type        = bool
  default     = true
}

variable "enable_default_standards" {
  description = "Enable default standards when Security Hub is enabled"
  type        = bool
  default     = false
}
