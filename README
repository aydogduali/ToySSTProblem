[![Python 3.11](https://img.shields.io/badge/Python-3.11-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/downloads/release/python-3110/)

# Toy SST Problem

A simple toy example of training a model to predict SST at time t + 24 hours, on a global 2-degree grid, using the SST and 2m air temperature at time t.

The problem has been formulated to give a very trivial example of training a model, and running inference (making predictions), within the [Anemoi](https://anemoi.readthedocs.io/) ecosystem.

It is not expected that this model will perform well — it is just a proof of concept that can be run in minutes, and allows users to get used to training and predicting with ML models within Anemoi.

Data comes from the ECMWF operational model.

## Notebooks

| Notebook | Description |
|---|---|
| `training_ToySST.ipynb` | Walk through the training configuration, run training, and inspect metrics with MLflow. |
| `inference_ToySST.ipynb` | Load a checkpoint, run a 15-day SST forecast, and plot predictions vs. truth. |

## Environment Setup

Both notebooks require **Python 3.11** and the packages listed in `requirements.txt`.

### Option 1 — pip (virtual environment)

```bash
python3.11 -m venv venv
source venv/bin/activate
pip install --no-cache-dir -r requirements.txt
```

### Option 2 — conda

```bash
conda create -n toysst python=3.11 -y
conda activate toysst
pip install --no-cache-dir -r requirements.txt
```

### Option 3 — Docker

```bash
docker build -t toysst .
docker run --gpus all -p 8888:8888 toysst
```

### HPC notes (ECMWF Atos, EWC, EDITO)

On ECMWF HPC systems the default `$TMPDIR` quota can be too small for large wheels. Override it when installing:

```bash
TMPDIR=/tmp pip install --no-cache-dir -r requirements.txt
```

If your `$HOME` quota is tight, install into `$PERM` instead:

```bash
pip install --no-cache-dir --prefix=$PERM/pip_packages -r requirements.txt
export PYTHONPATH=$PERM/pip_packages/lib/python3.11/site-packages:$PYTHONPATH
export PATH=$PERM/pip_packages/bin:$PATH
```

On EDITO or EWC the correct environment and data may already be in place.

## Quick Start

If running on an interactive server with only notebook access, clone the repository with:

```
!git clone https://github.com/RachelFurner/ToySSTProblem.git
```

Both notebooks include cells that download the required data (a zarr dataset and pre-trained model outputs) from S3 cloud storage. Set `need_data = True` in the first data cell to pull them automatically.

## Repository Structure

```
├── training_ToySST.ipynb     # Training notebook
├── inference_ToySST.ipynb    # Inference notebook
├── training_configs/         # Hydra / OmegaConf YAML configs
│   ├── ToySST.yaml           #   Main config (entry point)
│   ├── data/                 #   Data format & preprocessing
│   ├── dataloader/           #   Batch size, splits, etc.
│   ├── diagnostics/          #   Logging, plots, evaluation
│   ├── graph/                #   Graph construction options
│   ├── model/                #   Architecture definitions
│   ├── system/               #   Hardware & I/O paths
│   └── training/             #   LR schedule, loss, scalers
├── inference_ToySST.yaml     # Inference run config
├── requirements.txt          # Python dependencies
└── Dockerfile                # Container build file
```

## Key Dependencies

| Package | Version | Purpose |
|---|---|---|
| `anemoi-training` | 0.9.0 | Model training pipeline |
| `anemoi-inference` | 0.9.0 | Checkpoint loading & forecasting |
| `anemoi-models` | 0.12.0 | Graph-transformer architecture |
| `anemoi-graphs` | 0.8.4 | Graph construction utilities |
| `anemoi-datasets` | 0.5.35 | Zarr dataset access |
| `torch` | 2.6.0 (CUDA 12.4) | Deep learning framework |

## License

See [LICENSE](LICENSE) for details.
