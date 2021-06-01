import argparse

from nbconvert import PythonExporter

# Parse input nb path
parser = argparse.ArgumentParser(description="Execute notebook")
parser.add_argument("--input_nbs", nargs='+', type=str, help="Input notebook")
parser.add_argument("--output_pys", nargs='+', type=str, help="Output python script")
args = parser.parse_args()
input_nbs = args.input_nbs
output_pys = args.output_pys

# Export as python
exporter = PythonExporter()
for nb, py in zip(input_nbs, output_pys):
    body, _ = exporter.from_filename(nb)
    with open(py, "w+") as f:
        f.write(body)
