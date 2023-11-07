variable "project_id" {
  default     = "winter-field-401115"
  description = "Replace with your project ID"
}

variable "region" {
  default     = "europe-west4"
  description = "Replace with your region"
}

variable "zones" {
  default     = ["europe-west4-a", "europe-west4-b", "europe-west4-c"]
  description = "Replace with your zones array"
}

variable "environment" {
  default     = "qa"
  description = "only accepts qa or prod"

  validation {
    condition     = var.environment == "qa" || var.environment == "prod"
    error_message = "environment must be either qa or prod"
  }
}