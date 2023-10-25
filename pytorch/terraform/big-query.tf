resource "google_project_service" "bigquery" {
  project = var.project_id
  service = "bigquery.googleapis.com"
}

resource "google_bigquery_dataset" "example_dataset" {
  dataset_id = "example_dataset"
  project    = var.project_id
}

resource "google_bigquery_table" "user_table" {
  dataset_id = google_bigquery_dataset.example_dataset.dataset_id
  table_id   = "User"
  project    = var.project_id

  schema = file("big-query-schema.json")
}





