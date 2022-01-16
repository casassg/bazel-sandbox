# Bazel experiments

This is just a catch all for experiments I want to do with bazel, I don't plan to maintain this actively, just mostly trying things in a repo publicly 

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


## Multi-stage container builds

### copy_layer

Similar to docker multi-stage, we can extract files from one image to use in another. This target generates a layer that can be used with container_image target

Example: `bazel run src/py:py_image`
Source: [tools/container](tools/container)


## Misc

**Updating 3rdparty:**
- Change requirements.in
- Run `bazel run //3rdparty/py:requirements.update`
