import argparse
import logging
import sys
import uuid

import papermill as pm
from ipykernel.kernelspec import write_kernel_spec
from jupyter_client.kernelspec import KernelSpecManager

logging.getLogger("papermill").setLevel(logging.INFO)

uuid_hex = uuid.uuid4().hex
parser = argparse.ArgumentParser(description="Execute notebook")
parser.add_argument("input_nb", type=str, help="Input notebook")

kernel_spec_path = write_kernel_spec()
manager = KernelSpecManager()
manager.install_kernel_spec(kernel_spec_path, kernel_name=uuid_hex)
args = parser.parse_args()

pm.execute_notebook(
    input_path=args.input_nb,
    output_path=uuid_hex + ".ipynb",
    kernel_name=uuid_hex,
    log_output=True,
    progress_bar=False,
    stdout_file=sys.stdout,
    stderr_file=sys.stderr,
)
manager.remove_kernel_spec(uuid_hex)
