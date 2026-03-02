from kfp import dsl
from kfp import compiler

@dsl.component(
    base_image="us-central1-docker.pkg.dev/mlops-ent-system/mlops-repo/gpu-trainer:v1"
)
def train_model_cpu(project_id: str, bucket_name: str):
    import subprocess
    # Note: Running on 1 CPU will be slow, but it will PROVE the pipeline works
    subprocess.run(["python3", "src/train.py", f"--project={project_id}", f"--bucket={bucket_name}"])

@dsl.pipeline(
    name="enterprise-cpu-min-pipeline",
    description="Forcing n1-standard-1 to fit 1-CPU quota"
)
def pipeline(project_id: str, bucket_name: str):
    train_task = train_model_cpu(
        project_id=project_id,
        bucket_name=bucket_name
    )
    
    # Use .set_machine_type to force the smallest possible instance
    train_task.set_machine_type('n1-standard-1') 
    train_task.set_cpu_limit('1')
    train_task.set_memory_limit('3.75G')

if __name__ == "__main__":
    compiler.Compiler().compile(
        pipeline_func=pipeline, package_path="cpu_pipeline.yaml"
    )