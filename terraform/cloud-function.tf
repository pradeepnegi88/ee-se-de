# Upload CSV files to the storage bucket
resource "google_storage_bucket_object" "movies_csv" {
  name   = "movies_all.csv"
  bucket = google_storage_bucket.se-data-landing-pradeep.name
  source = "../movies_all.csv"
  depends_on = [google_cloudfunctions_function.load_csv_to_bigquery_based_on_prefix]

}

resource "google_storage_bucket_object" "ratings_csv" {
  name   = "ratings_all.csv"
  bucket = google_storage_bucket.se-data-landing-pradeep.name
  source = "../ratings_all.csv"
  depends_on = [google_cloudfunctions_function.load_csv_to_bigquery_based_on_prefix]

}

# Create Cloud Function ZIP file locally using local-exec provisioner
resource "null_resource" "create_cloud_function_zip" {
  provisioner "local-exec" {
    command = "cd ../cloudfunction && zip -r ../cloud_function.zip ."
  }

  triggers = {
    always_run = "${timestamp()}" # Ensures this runs on every apply
  }
}

# Upload the Cloud Function ZIP file to the storage bucket
resource "google_storage_bucket_object" "cloud_function" {
  name   = "cloud_function.zip"
  bucket = google_storage_bucket.se-data-landing-pradeep.name
  source = "../cloud_function.zip"

  depends_on = [null_resource.create_cloud_function_zip]
}

# Define the Cloud Function for loading movies CSV to BigQuery
resource "google_cloudfunctions_function" "load_csv_to_bigquery_based_on_prefix" {
  name                = "load_csv_to_bigquery_based_on_prefix"
  description         = "Load Movies CSV to BigQuery on file upload"
  runtime             = "python310"
  entry_point         = "load_csv_to_bigquery_based_on_prefix"
  region              = var.region
  available_memory_mb = 512
  timeout             = 540  

  source_archive_bucket = google_storage_bucket.se-data-landing-pradeep.name
  source_archive_object = google_storage_bucket_object.cloud_function.name

  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = google_storage_bucket.se-data-landing-pradeep.name
  }
}

# IAM binding to allow all users to invoke the Cloud Function
resource "google_cloudfunctions_function_iam_member" "movies_invoker" {
  project        = google_cloudfunctions_function.load_csv_to_bigquery_based_on_prefix.project
  region         = google_cloudfunctions_function.load_csv_to_bigquery_based_on_prefix.region
  cloud_function = google_cloudfunctions_function.load_csv_to_bigquery_based_on_prefix.name
  role           = "roles/cloudfunctions.invoker"
  member         = "allUsers"
}
