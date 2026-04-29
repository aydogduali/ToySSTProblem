## Script used by Dockerfile to download the ToySST dataset and pretrained outputs during 
## build. This ensures that the dataset and pretrained outputs are available in the container
## in the correct location without needing to download them at runtime.

import tarfile
import urllib.request
import zarr
import s3fs
from pathlib import Path

path = Path("/LocalDir/ToySSTDataset.zarr")

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

pretrained_path = Path("/LocalDir/pretrained_outputs")

if pretrained_path.exists():
    print("Pretrained outputs already in place")
else:
    print("Downloading pretrained outputs during build...")
    url = "https://object-store.os-api.cci1.ecmwf.int/ecmwf-training-nwp-ml/pretrained_outputs.tgz"
    with urllib.request.urlopen(url) as response:
        with tarfile.open(fileobj=response, mode="r|gz") as tar:
            tar.extractall(path="/LocalDir")
    print("Pretrained outputs download complete")

