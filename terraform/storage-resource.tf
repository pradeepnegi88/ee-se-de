resource "google_storage_bucket" "se-data-landing-pradeep" {
  name                     = var.bucket_name
  location                 = "US"
  force_destroy            = true
  public_access_prevention = "enforced"
}