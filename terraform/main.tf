provider "google" {
  project = var.project_id
  region  = var.region
}

# 1. Enable Required Google APIs
resource "google_project_service" "enabled_apis" {
  for_each = toset([
    "aiplatform.googleapis.com",      # Vertex AI
    "artifactregistry.googleapis.com", # Container Registry
    "bigquery.googleapis.com",         # Data Warehouse
    "storage.googleapis.com",          # Cloud Storage
    "cloudbuild.googleapis.com"        # CI/CD
  ])
  service            = each.key
  disable_on_destroy = false
}

# 2. Artifact Registry (Where Docker images for training/inference live)
resource "google_artifact_registry_repository" "ml_repo" {
  depends_on    = [google_project_service.enabled_apis]
  location      = var.region
  repository_id = "mlops-repo"
  description   = "Docker repository for MLOps pipeline components"
  format        = "DOCKER"
}

# 3. Cloud Storage Bucket (Where model.joblib and metadata are stored)
resource "google_storage_bucket" "model_artifacts" {
  depends_on    = [google_project_service.enabled_apis]
  name          = "${var.project_id}-ml-artifacts"
  location      = var.region
  force_destroy = true
  uniform_bucket_level_access = true
}

# 4. BigQuery Dataset (The source for training data and sink for drift logs)
resource "google_bigquery_dataset" "ml_data" {
  depends_on = [google_project_service.enabled_apis]
  dataset_id = "mlops_enterprise_ds"
  location   = "US" # Multi-regional is standard for BQ
}