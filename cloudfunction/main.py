import pandas as pd
from google.cloud import storage, bigquery

def load_csv_to_bigquery(event, context):
    client = bigquery.Client()
    bucket_name = event['bucket']
    file_name = event['name']

    dataset_id = "movies_data_pradeep"
    table_id = "movies_raw"
    dataset_ref = client.dataset(dataset_id)
    table_ref = dataset_ref.table(table_id)

    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(file_name)
    
    with blob.open("r") as f:
        df = pd.read_csv(f)

    job_config = bigquery.LoadJobConfig(
        autodetect=True,
        write_disposition="WRITE_APPEND",
    )
    
    load_job = client.load_table_from_dataframe(
        df, table_ref, job_config=job_config
    )
    
    load_job.result()
    print(f"Loaded {file_name} into {dataset_id}.{table_id}")
