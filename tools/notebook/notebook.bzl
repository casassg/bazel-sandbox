load("@rules_python//python:defs.bzl", "py_binary")
load("@my_deps//:requirements.bzl", "requirement")

def nb_binary(name, src, deps=[], visibility=None):
  """Run notebook natively

  Args:
    name: Target name.
    src: Notebook file to be executed.
    deps: Dependencies needed for executing notebook.
  """
  return py_binary(
    name=name,
    main='notebook.py',
    srcs=['//tools/notebook:notebook.py'],
    args = ['$(location '+src +')',],
    data=[src],
    deps=[
      # Add papermill and ipykernel as deps
      requirement('papermill'),
      requirement('ipykernel'),
    ] + deps,
    
  )


  