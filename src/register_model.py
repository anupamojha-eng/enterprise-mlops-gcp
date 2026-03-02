from google.cloud import aiplatform

aiplatform.init(project="825026630468", location="us-central1")

model = aiplatform.Model.upload(
    display_name="enterprise-validation-model",
    artifact_uri="gs://mlops-ent-system-ml-artifacts/model/", # Path where local run saved it
    serving_container_image_uri="us-docker.pkg.dev/vertex-ai/prediction/sklearn-cpu.1-0:latest"
)

print(f"Model registered: {model.resource_name}")