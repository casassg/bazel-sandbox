"""Extract files from a flattened container image into a new tar file.
"""
import tarfile
import argparse
import copy

parser = argparse.ArgumentParser(description="Extract files from folder")
parser.add_argument("--tar", type=str, help="Tar")
parser.add_argument("--path", type=str, help="Folder to extract files from")
parser.add_argument("--out", type=str, help="Output tar")
parser.add_argument("--dest_path", type=str, help="Path where to copy this inside the new tar s/path/dest_path")
args = parser.parse_args()

# We remove the / prefix for dealing w tars.
dest_path = args.dest_path[1:] if args.dest_path else None
path = args.path[1:]

# For each file we check only those files we need.
with tarfile.open(args.tar) as input_tar:
    with tarfile.open(args.out, "w") as output_tar:
        for member in input_tar.getmembers():
            if member.name.startswith(path):
                dest_name = (
                    member.name.replace(path, dest_path)
                    if dest_path
                    else member.name
                )
                dest_tar_info = copy.deepcopy(member)
                dest_tar_info.name = dest_name
                output_tar.addfile(
                    dest_tar_info, input_tar.extractfile(member.name)
                )
