import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from google.cloud import bigquery
from google.cloud import storage
import joblib
import argparse
import os

def train_and_upload(project_id, bucket_name):
    # 1. Fetch Data from BigQuery (Using a public dataset for a quick demo)
    client = bigquery.Client(project=project_id)
    query = """
        SELECT * FROM `bigquery-public-data.ml_datasets.iris` LIMIT 1000
    """
    df = client.query(query).to_dataframe()
    
    # 2. Prep and Train
    X = df.drop('species', axis=1)
    y = df['species']
    model = RandomForestClassifier(n_estimators=10)
    model.fit(X, y)
    print("✅ Model trained successfully.")

    # 3. Save locally first
    local_file = 'model.joblib'
    joblib.dump(model, local_file)

   # 4. Upload to GCS (Crucial for Vertex AI Model Registry)
    # Update this line to pass the project_id
    storage_client = storage.Client(project=project_id) 
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob('model/model.joblib')
    blob.upload_from_filename(local_file)
    print(f"🚀 Model uploaded to gs://{bucket_name}/model/model.joblib")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--project', type=str, required=True)
    parser.add_argument('--bucket', type=str, required=True)
    args = parser.parse_args()
    
    train_and_upload(args.project, args.bucket)