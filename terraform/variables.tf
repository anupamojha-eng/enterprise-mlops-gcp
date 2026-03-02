variable "project_id" {
  type        = string
  description = "The GCP Project ID (mlops-ent-system)"
}

variable "region" {
  type        = string
  default     = "us-central1"
  description = "The default GCP region for resources"
}