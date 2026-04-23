FROM python:3.11.10-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    g++ \
    libgeos-dev \
    libproj-dev \
    proj-bin \
    proj-data \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ✅ Download dataset at build time
RUN python - <<'EOF'
import zarr, s3fs
from pathlib import Path

path = Path("ToySSTDataset.zarr")

if path.exists():
    print("ToySST dataset already in place")
else:
    print("Downloading ToySST dataset during build...")

    s3 = s3fs.S3FileSystem(
        anon=True,
        client_kwargs={"endpoint_url": "https://object-store.os-api.cci1.ecmwf.int"}
    )

    store = s3fs.S3Map(
        root="s3://ecmwf-training-nwp-ml/ToySSTDataset.zarr",
        s3=s3,
        check=False
    )

    zarr.copy_store(store, zarr.DirectoryStore(path))

    print("Download complete")
EOF

COPY . .

CMD ["python", "-m", "jupyterlab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--ServerApp.token=", "--ServerApp.password="]
