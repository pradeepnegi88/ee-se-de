resource "google_bigquery_dataset" "movies_data_pradeep" {
  dataset_id    = var.data_set
  location      = var.region
  friendly_name = "Movies Data ${var.data_set}"
  description   = "Raw Data"
  labels = {
    environment = "default"
  }
}
