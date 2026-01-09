variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "recording_all_resources" {
  description = "Record all supported resource types"
  type        = bool
  default     = true
}
