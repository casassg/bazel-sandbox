package(default_visibility = ["//visibility:public"])

licenses(["notice"])

nb_test_suite(
  name="test",
  srcs=glob(["test*.ipynb"]),
  deps=[
    requirement('tensorflow'),
    "//src/py:lib",
    ":nb_lib"
  ]
)

nb_test(
  name="test_2",
  srcs=["test_2.ipynb"],
  deps=[
    requirement('tensorflow'),
    "//src/py:lib",
    ":nb_lib"
  ]
)

nb_binary(
  name="run",
  srcs=["run.ipynb"]
)

nb_library(
  name="nb_lib",
  srcs=glob(["nb_lib/*.ipynb"]),
  deps=[
    requirement('requests')
  ],
  imports=["."],
)