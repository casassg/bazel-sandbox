import argparse
import logging
import sys
import uuid

import papermill as pm
from ipykernel.kernelspec import write_kernel_spec
from jupyter_client.kernelspec import KernelSpecManager

# Parse input nb path
parser = argparse.ArgumentParser(description="Execute notebook")
parser.add_argument("input_nbs", nargs="+", type=str, help="Input notebooks")
args = parser.parse_args()
input_nbs = args.input_nbs

# Generate ephemeral kernel with current python environment
kernel_spec_path = write_kernel_spec()
manager = KernelSpecManager()
uuid_hex = uuid.uuid4().hex
manager.install_kernel_spec(kernel_spec_path, kernel_name=uuid_hex)

# Set logger and execute notebook
logging.getLogger("papermill").setLevel(logging.INFO)
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
