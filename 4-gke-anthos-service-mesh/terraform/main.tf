terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
}


# the IAM service account 
resource "google_service_account" "iam_sa" {
  account_id   = "iam-sa-${var.environment}"
  display_name = "Service Account For Workload Identity"
}

// needed to pull images from Artifact Registry
resource "google_project_iam_member" "artifactregistry_reader" {
  project = var.project_id
  role = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.iam_sa.email}"
}