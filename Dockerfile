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

# Generate a random token at startup so the server is not left open to the network.
# The full URL including the token is printed to the terminal when the container
# starts — copy and paste it into your browser. If you ran the container detached
# (-d flag), retrieve the URL with: docker logs <container-id>
CMD ["sh", "-c", "python -m jupyterlab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --ServerApp.token=$(openssl rand -hex 24) --notebook-dir=/LocalDir"]
