# Bazel experiments

This is just a catch all for experiments I want to do with bazel, I don't plan to maintain this actively, just mostly trying thing in a repo publicly 

## Python Notebook targets in bazel

Notebooks can be easily converted to python scripts or executed using tooling like nbconvert or papermill. This means, that a system like bazel that can easily chain operations, may be a good fit for developing python libraries with notebooks.

Currently this is mostly undocumented, but you can see some simple usages on [src/py/BUILD](src/py/BUILD) and [src/nb/BUILD](src/nb/BUILD) folder, or just read below :D

### nb_binary

Executing notebooks using papermill. This target wraps a py_binary to easily execute a notebook using papermill.

Example: `bazel run //src/nb:test`
Source: [tools/notebook](tools/notebook)

### nb_library

Inspired largely from [nbdev](https://nbdev.fast.ai/), it transforms a notebook into a python script (py_library). This can then be used to import content of the notebook to native python targets (py_tests, py_binary, py_library).

Example: `bazel run //src/py:main`
Source: [tools/notebook](tools/notebook)
