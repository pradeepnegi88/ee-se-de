provider "google" {
  # Configuration options
  credentials = file("/Users/pradeepnegi/.config/gcloud/application_default_credentials.json")
  project     = var.project
  region      = var.region
}