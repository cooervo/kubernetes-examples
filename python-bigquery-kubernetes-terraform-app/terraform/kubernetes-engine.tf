resource "google_container_cluster" "cluster" {
  name               = "gke-cluster-${var.environment}"
  location           = var.region
  project            = var.project_id
  lifecycle {
    ignore_changes = [
      # Ignore changes to min-master-version as that gets changed
      # after deployment to minimum precise version Google has
      min_master_version,
    ]
  }
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "node-pool-${var.environment}"
  location   = var.region
  project    = var.project_id
  cluster    = google_container_cluster.cluster.name
  node_count = 1
  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }
  node_config {
    preemptible  = true
    machine_type = "e2-medium"
    # Google recommends custom service accounts that have cloud-platform scope
    # and permissions granted via IAM Roles.
    service_account = google_service_account.iam_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
  lifecycle {
    ignore_changes = [
      # Ignore changes to node_count, initial_node_count and version
      # otherwise node pool will be recreated if there is drift between what 
      # terraform expects and what it sees
      initial_node_count,
      node_count,
      version
    ]
  }
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

// Needed for CRUD operations on BigQuery
resource "google_project_iam_member" "bigquery_dataEditor" {
  project = var.project_id
  role = "roles/bigquery.dataEditor" # documentation: https://cloud.google.com/bigquery/docs/access-control
  member = "serviceAccount:${google_service_account.iam_sa.email}"
}

// Needed for running queries on BigQuery
resource "google_project_iam_member" "bigquery_jobUser" {
  project = var.project_id
  role = "roles/bigquery.jobUser" # documentation: https://cloud.google.com/bigquery/docs/access-control
  member = "serviceAccount:${google_service_account.iam_sa.email}"
}
