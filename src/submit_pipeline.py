from google.cloud import aiplatform

def submit_pipeline():
    aiplatform.init(project="mlops-ent-system", location="us-central1")

    job = aiplatform.PipelineJob(
        display_name="min-cpu-success-run",
        template_path="cpu_pipeline.yaml",
        pipeline_root="gs://mlops-ent-system-ml-artifacts/pipeline_root",
        parameter_values={
            "project_id": "mlops-ent-system",
            "bucket_name": "mlops-ent-system-ml-artifacts"
        },
        enable_caching=False 
    )

    job.submit(service_account="mlops-pipeline-runner@mlops-ent-system.iam.gserviceaccount.com")

if __name__ == "__main__":
    submit_pipeline()