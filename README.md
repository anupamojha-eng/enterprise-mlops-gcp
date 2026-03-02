# Enterprise MLOps: Containerized Training & Vertex AI Registry Pipeline

This repository demonstrates a production-grade MLOps workflow on **Google Cloud Platform (GCP)**. It automates the transition from raw data in **BigQuery** to a versioned, deployment-ready asset in the **Vertex AI Model Registry**.



## 🏗 High-Level Architecture
The project bypasses traditional "notebook-based" ML in favor of a **decoupled, containerized architecture**:

* **Data Layer:** Features are ingested directly from **BigQuery** (Iris Public Dataset) using the Google Cloud Python SDK.
* **Compute Layer:** Training logic is encapsulated in a **Docker** container to ensure environment parity between local development and cloud execution.
* **Artifact Layer:** Serialized model objects (`.joblib`) are persisted in **Google Cloud Storage (GCS)**, acting as a centralized Model Store.
* **Governance Layer:** Models are registered in the **Vertex AI Model Registry**, providing lineage, versioning, and a path to managed deployment.

---

## 🚀 Engineering Resilience: The "Pivot" Strategy
During development, a standard GCP project quota limit (1-CPU cap) was encountered for Vertex AI Custom Training. 

**The Solution:** Instead of halting, I validated the entire stack via **Local Container Execution**. This proved that the Dockerized training logic and Cloud integrations (BQ/GCS/Vertex) were functional, ensuring a "Production-Ready" state regardless of temporary cloud infrastructure constraints.



---

## 🛠 Tech Stack
* **Orchestration:** Vertex AI SDK (Model Registry & Initialization)
* **Data:** Google BigQuery (SQL-based feature extraction)
* **Containerization:** Docker (Base Image: `deeplearning-platform-release/gcr.io/base-cu113.py310`)
* **Storage:** Google Cloud Storage (GCS)
* **ML Framework:** Scikit-Learn (Random Forest Classifier)

---

## 📂 Project Structure
```text
.
├── src/
│   ├── train.py           # BigQuery Ingestion + Training + GCS Upload
│   ├── register_model.py  # Vertex AI Registration Logic
│   └── test_prediction.py # Local Inference Validation
├── Dockerfile             # Container definition for the Training Job
├── requirements.txt       # Python dependencies
└── README.md
```

---

## How to Run & Validate
```bash

docker build -t local-trainer .
```

## Execute Containerized Training
This command maps local Google Application Default Credentials (ADC) into the container:

```bash
docker run -it \
  -v $HOME/.config/gcloud/application_default_credentials.json:/tmp/keys/creds.json \
  -e GOOGLE_APPLICATION_CREDENTIALS=/tmp/keys/creds.json \
  local-trainer \
  python3 src/train.py --project=[PROJECT_ID] --bucket=[BUCKET_NAME]
  ```

## Register with Vertex AI Model Registry

```bash
python3 src/register_model.py
```

## Verify Inference (Sanity Check)

```bash
python3 src/test_prediction.py
```

## 📈 Future Roadmap & Production Scaling
To move beyond this validation demo, the architecture is ready for:

* CI/CD Integration: Automating the Docker build and Registry push via Google Cloud Build on every git push.

* Model Monitoring: Enabling Vertex AI Model Monitoring on a deployed Endpoint to detect Feature Drift and trigger automated retraining.

* Batch Inference: Leveraging Vertex AI Batch Prediction jobs to score multi-million row datasets directly from BigQuery.
