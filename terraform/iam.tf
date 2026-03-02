# Create a dedicated Service Account for ML Pipelines
resource "google_service_account" "pipeline_sa" {
  account_id   = "mlops-pipeline-runner"
  display_name = "Service Account for Vertex AI Pipelines"
}

# Grant necessary roles to the Service Account
resource "google_project_iam_member" "pipeline_roles" {
  for_each = toset([
    "roles/aiplatform.admin",   # Full Vertex AI access
    "roles/storage.admin",     # Access to read/write model artifacts
    "roles/bigquery.admin",    # Access to training data
    "roles/artifactregistry.reader" # Ability to pull containers
  ])
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.pipeline_sa.email}"
}