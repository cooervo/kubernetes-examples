terraform {
  required_version = "~> 1.6.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.7.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.29.0"
    }
  }
}


provider "google" {
  project     = var.gcp_project_id
  region      = var.gcp_region
  credentials = file("gcp_creds.json")
}
