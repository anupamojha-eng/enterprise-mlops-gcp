# Enterprise MLOps Framework (GCP + Vertex AI)

This repository implements a **Level 2 MLOps Maturity** system on Google Cloud Platform. It features automated infrastructure, continuous training (CT), and model monitoring with automated drift-triggered retraining.

## 🏗 System Architecture
The system follows a decoupled architecture:
- **Infrastructure:** Managed via Terraform (IaC).
- **Data Layer:** BigQuery (Warehouse) + Vertex AI Feature Store.
- **Orchestration:** Vertex AI Pipelines (Kubeflow KFP).
- **Model Governance:** Vertex AI Model Registry & ML Metadata.
- **Serving:** Vertex AI Endpoints with Request/Response logging.



## 🚀 Key Features
- **Automated Drift Detection:** Monitors serving data for statistical skew (KS-test) and triggers retraining via Pub/Sub.
- **CI/CD Pipelines:** GitHub Actions for automated unit testing and Cloud Build for containerizing training jobs.
- **Feature Store Integration:** Ensures zero training-serving skew by using a unified feature repository.
- **Lineage Tracking:** Full audit trail from raw data hash to deployed model binary.

## 🛠 Setup & Deployment
1. **Initialize Infrastructure:**
   ```bash
   cd terraform
   terraform init
   terraform apply -var="project_id=YOUR_PROJECT_ID"

2. **Compile Pipeline:**
    ```bash
    python pipelines/training_pipeline.py
    ```