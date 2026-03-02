#!/bin/bash

# Configuration
PROJECT_ID="mlops-ent-system"
REGION="us-central1"

echo "🚀 Starting Infrastructure Setup for $PROJECT_ID..."

# 1. Initialize Terraform
echo "📦 Initializing Terraform..."
cd terraform
terraform init

# 2. Apply Infrastructure
echo "🏗 Building Infrastructure (Applying)..."
terraform apply -var="project_id=$PROJECT_ID" -var="region=$REGION" -auto-approve

if [ $? -eq 0 ]; then
    echo "✅ Terraform Apply Successful!"
else
    echo "❌ Terraform Apply Failed!"
    exit 1
fi

echo "🔍 Validating Resources..."

# 3. Validation Logic
echo "------------------------------------------------"
# Check Bucket
if gcloud storage buckets list --project=$PROJECT_ID | grep -q "$PROJECT_ID-ml-artifacts"; then
    echo "✅ Cloud Storage Bucket: FOUND"
else
    echo "❌ Cloud Storage Bucket: NOT FOUND"
fi

# Check BigQuery
if bq ls --project_id=$PROJECT_ID | grep -q "mlops_enterprise_ds"; then
    echo "✅ BigQuery Dataset: FOUND"
else
    echo "❌ BigQuery Dataset: NOT FOUND"
fi

# Check Service Account
if gcloud iam service-accounts list --project=$PROJECT_ID | grep -q "mlops-pipeline-runner"; then
    echo "✅ Service Account: FOUND"
else
    echo "❌ Service Account: NOT FOUND"
fi

echo "------------------------------------------------"
echo "🎯 Infrastructure is ready for MLOps Step 3!"
