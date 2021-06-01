load("@rules_python//python:defs.bzl", "py_binary", "py_library", "py_test")
load("@my_deps//:requirements.bzl", "requirement")

def nb_binary(name, srcs, deps=[], visibility=None, **kwargs):
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
    args = ['$(location '+ src +')' for src in srcs],
    data=srcs,
    deps=[
      # Add papermill and ipykernel as deps
      requirement('papermill'),
      requirement('ipykernel'),
    ] + deps,
    **kwargs
  )

def nb_library(name, srcs, deps=[], visibility=None, **kwargs):
  """Notebook python library

  Args:
    srcs: Notebooks to generate as python library.
    deps: Dependencies for library.
    name: Name for library.
  """
  for src in srcs:
    if not src.endswith('.ipynb'):
      fail('nb_library sources must be ipynb files. Found: %s' % src)

  outs = [o.replace('.ipynb', '.py') for o in srcs]
  native.genrule(
    name = name + '-nbconvert',
    srcs = srcs,
    outs = outs,
    cmd = "$(location //tools/notebook:nb_lib_convert) --input_nbs $(SRCS)  --output_pys $(OUTS)",
    tools = ["//tools/notebook:nb_lib_convert"],
    visibility = ["//visibility:private"],
  )
  return py_library(
    name=name,
    srcs=outs,
    deps=deps,
    visibility=visibility,
    **kwargs
  )
  


def nb_test(name, srcs, deps=[], **kwargs):
  return py_test(
    name=name,
    main='notebook_bin.py',
    srcs=['//tools/notebook:notebook_bin.py'],
    args = ['$(location '+ src +')' for src in srcs],
    data=srcs,
    deps=[
      # Add papermill and ipykernel as deps
      requirement('papermill'),
      requirement('ipykernel'),
    ] + deps,
    **kwargs
  )