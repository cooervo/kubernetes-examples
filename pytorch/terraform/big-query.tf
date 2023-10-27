resource "google_project_service" "bigquery" {
  project = var.project_id
  service = "bigquery.googleapis.com"
}

resource "google_bigquery_dataset" "example_dataset" {
  dataset_id = "example_dataset"
  project    = var.project_id
}

# provision an empty user_table, you can insert a sample row manually through console and test the flask GET query works for /users
resource "google_bigquery_table" "user_table" {
  dataset_id = google_bigquery_dataset.example_dataset.dataset_id
  table_id   = "User"
  project    = var.project_id

  schema = file("big-query-schema.json")
}





