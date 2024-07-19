from google.cloud import bigquery
from google.cloud import storage
from datetime import datetime

def load_csv_to_bigquery(bucket_name, file_name, dataset_id, table_id):
    client = bigquery.Client()
    storage_client = storage.Client()

    print(f"Loading new data from: {file_name} into BigQuery table {table_id}")

    # Fetch the schema of the destination table
    schema_list = get_table_schema(client, dataset_id, table_id)
    job_config = get_job_config(schema_list)

    try:
        # Load data into BigQuery
        uri = f"gs://{bucket_name}/{file_name}"
        load_job = client.load_table_from_uri(
            uri,
            f"{dataset_id}.{table_id}",
            job_config=job_config,
        )
        load_job.result()  # Waits for the job to complete.

        destination_table = client.get_table(f"{dataset_id}.{table_id}")
        print(f"Loaded {destination_table.num_rows} rows into table {dataset_id}.{table_id}")

    except Exception as e:
        # Handle exceptions and log the error
        print(f"Error loading {file_name} into {dataset_id}.{table_id}: {e}")

def get_table_schema(client, dataset_id, table_id):
    table = client.get_table(f"{dataset_id}.{table_id}")
    schema_list = [
        bigquery.SchemaField(name=field.name, field_type=field.field_type, mode=field.mode)
        for field in table.schema
        if field.name != "load_date"
    ]
    return schema_list

def get_job_config(schema):
    job_config = bigquery.LoadJobConfig(
        schema=schema,
        write_disposition=bigquery.WriteDisposition.WRITE_APPEND,
        source_format=bigquery.SourceFormat.CSV,
        skip_leading_rows=1,
        autodetect=True,
        allow_jagged_rows=True
    )
    return job_config

def load_csv_to_bigquery_based_on_prefix(data, context):
    bucket_name = data['bucket']
    file_name = data['name']
    
    if file_name.startswith('movies'):
        load_csv_to_bigquery(bucket_name, file_name, "movies_data_pradeep", "movies_raw")
    elif file_name.startswith('ratings'):
        load_csv_to_bigquery(bucket_name, file_name, "movies_data_pradeep", "ratings_raw")
    else:
        print(f"Skipping file {file_name} as it does not match the expected prefixes 'movies_' or 'ratings_'")

