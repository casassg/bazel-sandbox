import argparse
import logging
import os
import sys
import tempfile
import uuid

import papermill as pm
from ipykernel.kernelspec import write_kernel_spec
from jupyter_client.kernelspec import KernelSpecManager

# Parse input nb path
parser = argparse.ArgumentParser(description="Execute notebook")
parser.add_argument("input_nbs", nargs="+", type=str, help="Input notebooks")
args = parser.parse_args()
input_nbs = args.input_nbs


# If we are on a test use TEST_TMPDIR from bazel
tmp_path = os.environ.get("TEST_TMPDIR", tempfile.mkdtemp())


# Generate ephemeral kernel with current python environment
uuid_hex = uuid.uuid4().hex
kernel_path = os.path.join(tmp_path, uuid_hex + ".json")
kernel_spec_path = write_kernel_spec(path=kernel_path)

# Set jupyter path so that installed kernel can be picked up by papermill automatically.
# Based on https://github.com/jupyter/jupyter_client/blob/3515e892955a7a3efea5c60f6ebaf568320e1f5a/jupyter_client/kernelspec.py#L324
os.environ["JUPYTER_PATH"] = os.path.join(tmp_path, "share", "jupyter")

# Install new kernel to tmp_path using prefix
manager = KernelSpecManager()
manager.install_kernel_spec(kernel_spec_path, prefix=tmp_path, kernel_name=uuid_hex)


logging.getLogger("papermill").setLevel(logging.INFO)

# For each notebook execute and redirect stdout and stderr to terminal
for input_nb in input_nbs:
    pm.execute_notebook(
        input_path=input_nb,
        output_path=input_nb.replace(".ipynb", "") + uuid_hex + ".ipynb",
        kernel_name=uuid_hex,
        log_output=True,
        progress_bar=False,
        stdout_file=sys.stdout,
        stderr_file=sys.stderr,
    )

# Remove ephemeral kernel
manager.remove_kernel_spec(uuid_hex)
