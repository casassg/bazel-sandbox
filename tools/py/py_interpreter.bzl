load("@rules_python//python:defs.bzl", "py_binary", "py_library")

def py_library2(name, deps = [], **kwargs):
    py_library(
        name = name,
        deps = deps,
        **kwargs
    )

    py_binary(
        name = name + ".repl",
        srcs = ["//tools/py:repl.py"],
        main = "//tools/py:repl.py",
        deps = [name] + deps,
    )



def py_binary2(name, deps = [], **kwargs):
    py_binary(
        name = name,
        deps = deps,
        **kwargs
    )

    py_binary(
        name = name + ".repl",
        srcs = ["//tools/py:repl.py"],
        main = "//tools/py:repl.py",
        deps = [name] + deps,
    )
