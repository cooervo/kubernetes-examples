variable "project_id" {
  default = "test-project-407120"
}

variable "region" {
  default = "europe-west1"
}

variable "main_network_cidr" {
  description = "CIDR range for the main subnet"
  type        = string
  default     = "10.2.0.0/16"
  validation {
    condition     = can(cidrhost(var.main_network_cidr, 0))
    error_message = "Must be valid IPv4 CIDR"
  }
}
