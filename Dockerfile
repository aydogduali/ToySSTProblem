FROM python:3.11.10-slim

RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    g++ \
    libgeos-dev \
    libproj-dev \
    proj-bin \
    proj-data \
    && rm -rf /var/lib/apt/lists/*

# Create the LocalDir layout
RUN mkdir -p /LocalDir/ToySSTProblem

WORKDIR /LocalDir/ToySSTProblem

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Download dataset into /LocalDir/ToySSTDataset.zarr
COPY download_dataset.py .
RUN python download_dataset.py

COPY . .

CMD ["python", "-m", "jupyterlab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--ServerApp.token=", "--ServerApp.password="]
