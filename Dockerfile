# Use a pre-configured Google Deep Learning image with CUDA and Python
FROM us-docker.pkg.dev/deeplearning-platform-release/gcr.io/base-cu113.py310

WORKDIR /app

# Install RAPIDS for GPU-accelerated DataFrames and ML
# This is what makes it "Enterprise Grade" for high-performance computing
RUN pip install --no-cache-dir cudf-cu11 cuml-cu11 cupy-cuda11x

# Install GCP libraries for data movement
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy our source code
COPY src/ ./src/
