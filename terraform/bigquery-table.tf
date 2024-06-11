resource "google_bigquery_table" "movies_raw" {
  dataset_id = google_bigquery_dataset.movies_data_pradeep.dataset_id
  table_id   = "movies_raw"

  schema = <<EOF
  [
    {"name": "adult", "type": "BOOLEAN", "mode": "NULLABLE"},
    {"name": "belongs_to_collection", "type": "STRING", "mode": "NULLABLE"},
    {"name": "budget", "type": "INTEGER", "mode": "NULLABLE"},
    {"name": "genres", "type": "STRING", "mode": "NULLABLE"},
    {"name": "homepage", "type": "STRING", "mode": "NULLABLE"},
    {"name": "id", "type": "INTEGER", "mode": "REQUIRED"},
    {"name": "imdb_id", "type": "STRING", "mode": "NULLABLE"},
    {"name": "original_language", "type": "STRING", "mode": "NULLABLE"},
    {"name": "original_title", "type": "STRING", "mode": "NULLABLE"},
    {"name": "overview", "type": "STRING", "mode": "NULLABLE"},
    {"name": "popularity", "type": "FLOAT", "mode": "NULLABLE"},
    {"name": "poster_path", "type": "STRING", "mode": "NULLABLE"},
    {"name": "production_companies", "type": "STRING", "mode": "NULLABLE"},
    {"name": "production_countries", "type": "STRING", "mode": "NULLABLE"},
    {"name": "release_date", "type": "DATE", "mode": "NULLABLE"},
    {"name": "revenue", "type": "INTEGER", "mode": "NULLABLE"},
    {"name": "runtime", "type": "FLOAT", "mode": "NULLABLE"},
    {"name": "spoken_languages", "type": "STRING", "mode": "NULLABLE"},
    {"name": "status", "type": "STRING", "mode": "NULLABLE"},
    {"name": "tagline", "type": "STRING", "mode": "NULLABLE"},
    {"name": "title", "type": "STRING", "mode": "NULLABLE"},
    {"name": "video", "type": "BOOLEAN", "mode": "NULLABLE"},
    {"name": "vote_average", "type": "FLOAT", "mode": "NULLABLE"},
    {"name": "vote_count", "type": "INTEGER", "mode": "NULLABLE"}
  ]
  EOF

  labels = {
    environment = "default"
  }
}
# feedback keep all type as string 

# load_date to find when data loaded 

# load all data 
