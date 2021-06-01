package(default_visibility = ["//visibility:public"])

licenses(["notice"])

nb_binary(
  name="test",
  src="test.ipynb",
  deps=[
    requirement('tensorflow'),
    "//src/py:lib",
    ":nb_lib"
  ]
)

nb_library(
  name="nb_lib",
  srcs=glob(["nb_lib/*.ipynb"]),
  deps=[
    requirement('requests')
  ],
  imports=["."],
)