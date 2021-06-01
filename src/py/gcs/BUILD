package(default_visibility = ["//visibility:public"])

licenses(["notice"])

py_library(
  name="lib",
  srcs=glob(["lib/*.py"]),
  imports=['.']
)

py_binary(
  name = "main",
  srcs = ["main.py"],
  deps = [
    "//src/py/gcs:lib",
    requirement("tensorflow"),
  ]
)
