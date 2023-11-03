variable "project_id" {
  default     = "winter-field-401115"
  description = "Replace with your project ID"
}

variable "region" {
  default     = "europe-west6"
  description = "Replace with your region"
}

variable "zones" {
  default     = ["europe-west6-a", "europe-west6-b", "europe-west6-c"]
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