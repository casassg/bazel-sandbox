import argparse

from nbconvert import PythonExporter

# Parse input nb path
parser = argparse.ArgumentParser(description="Execute notebook")
parser.add_argument("input_nb", type=str, help="Input notebook")
parser.add_argument("output_py", type=str, help="Output python script")
args = parser.parse_args()
input_nb = args.input_nb
output_py = args.output_py

# Export as python file
exporter = PythonExporter()
body, _ = exporter.from_filename(input_nb)
with open(output_py, "w+") as f:
    f.write(body)
