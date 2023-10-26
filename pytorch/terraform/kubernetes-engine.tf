resource "google_container_cluster" "cluster" {
  name               = "tutorial"
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
  name       = "tutorial-cluster-node-pool"
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
    service_account = google_service_account.workload-identity-user-sa.email
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
resource "google_service_account" "workload-identity-user-sa" {
  account_id   = "workload-identity-tutorial"
  display_name = "Service Account For Workload Identity"
}
resource "google_project_iam_member" "artifact_repository-role" {
  project = var.project_id
  role = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.workload-identity-user-sa.email}"
}
resource "google_project_iam_member" "workload_identity-role" {
  project = var.project_id
  role = "roles/bigquery.jobUser" # documentation: https://cloud.google.com/bigquery/docs/access-control
  member = "serviceAccount:${google_service_account.workload-identity-user-sa.email}"
  # member = "serviceAccount:${var.project_id}.svc.id.goog[workload-identity-test/workload-identity-user]"
}
resource "google_project_iam_member" "foobar-role" {
  project = var.project_id
  role = "roles/artifactregistry.createOnPushWriter"
  member = "serviceAccount:${google_service_account.workload-identity-user-sa.email}"
}