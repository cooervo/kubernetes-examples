# https://registry.terraform.io/providers/hashicorp/google/latest/docs
provider "google" {
  project = "k8s-llm-playground-401115"
  region  = "us-central1"
}

# https://www.terraform.io/language/settings/backends/gcs
terraform {
  backend "gcs" {
    bucket = "k8s-llm-playground-terraform-state"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}
