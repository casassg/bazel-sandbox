load("@rules_python//python:defs.bzl", "py_binary", "py_library")
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
    main='notebook_bin.py',
    srcs=['//tools/notebook:notebook_bin.py'],
    args = ['$(location '+src +')',],
    data=[src],
    deps=[
      # Add papermill and ipykernel as deps
      requirement('papermill'),
      requirement('ipykernel'),
    ] + deps,
    
  )

def nb_library(name, src, deps=[], visibility=None, imports=[]):
  out = src.replace('.ipynb', '.py')
  native.genrule(
    name = name + '-convert',
    srcs = [src],
    outs = [out],
    cmd = "$(location //tools/notebook:nb_lib_convert) $< $@",
    tools = ["//tools/notebook:nb_lib_convert"],
    visibility = ["//visibility:private"],
  )
  return py_library(
    name=name,
    srcs=[out],
    deps=deps,
    imports=imports,
    visibility=visibility
  )
  


  