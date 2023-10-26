provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket = "pytorch-cluster-remote-state" # TODO change to your GCP state bucket name
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

# module "workload-identity-gke-cluster" {
#   source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
#   name                = "workload-identity-gke-cluster" # the name to add in deploymeny.yml > spec.serviceAccountName
#   namespace           = "default" # TODO change to your namespace
#   project_id          = var.project_id
#   cluster_name        = "gke-${var.environment}"

#   roles               = [
#     "roles/bigquery.jobUser" # documentation: https://cloud.google.com/bigquery/docs/access-control
#     ]
# }

# module "workload-identity-gke-cluster" {
#   source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
#   name                = data.google_service_account.gke_sa.account_id # the name to add in deploymeny.yml > spec.serviceAccountName

#   use_existing_gcp_sa = true

#   namespace           = "default" # TODO change to your namespace
#   project_id          = var.project_id
#   cluster_name        = "gke-${var.environment}"

#   roles               = [
#     "roles/bigquery.jobUser" # documentation: https://cloud.google.com/bigquery/docs/access-control
#     ]

#       depends_on = [data.google_service_account.gke_sa]

# }
