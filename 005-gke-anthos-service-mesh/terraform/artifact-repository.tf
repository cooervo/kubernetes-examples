resource "google_artifact_registry_repository" "artifact_repository" {
  repository_id = "artifact-repository-${var.environment}"
  location      = var.region
  format        = "DOCKER"
  project       = var.project_id
}