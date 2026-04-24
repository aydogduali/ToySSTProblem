import zarr
import s3fs
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
