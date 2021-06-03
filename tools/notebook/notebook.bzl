"""Notebook targets for Bazel.
"""

load("@rules_python//python:defs.bzl", "py_binary", "py_library", "py_test")
load("@my_deps//:requirements.bzl", "requirement")

def _check_srcs(srcs):
    for src in srcs:
        if not src.endswith(".ipynb"):
            fail("sources must be ipynb files. Found: %s instead" % src)

def nb_binary(name, srcs, deps = [], visibility = None, **kwargs):
    """Run notebook natively

    Args:
      name: Target name.
      srcs: Notebook files to be executed. Execution will be sequential for each file in the list.
      deps: Dependencies needed for executing notebook.
      visibility: Visibility for binary.
      **kwargs: args for py_binary.
    """
    _check_srcs(srcs)
    return py_binary(
        name = name,
        main = "notebook_bin.py",
        srcs = ["//tools/notebook:notebook_bin.py"],
        args = ["$(location " + src + ")" for src in srcs],
        data = srcs,
        deps = [
            # Add papermill and ipykernel as deps
            requirement("papermill"),
            requirement("ipykernel"),
        ] + deps,
        **kwargs
    )

def nb_library(name, srcs, deps = [], visibility = None, **kwargs):
    """Notebook python library

    Args:
      name: Name for library.
      srcs: Notebooks to be translated to a python library.
      deps: Dependencies for library.
      visibility: Visibility for library.
      **kwargs: args for py_library

    """
    _check_srcs(srcs)

    outs = [o.replace(".ipynb", ".py") for o in srcs]
    native.genrule(
        name = name + "-nbconvert",
        srcs = srcs,
        outs = outs,
        cmd = "$(location //tools/notebook:nb_lib_convert) --input_nbs $(SRCS)  --output_pys $(OUTS)",
        tools = ["//tools/notebook:nb_lib_convert"],
        visibility = ["//visibility:private"],
    )
    py_library(
        name = name,
        srcs = outs,
        deps = deps,
        visibility = visibility,
        **kwargs
    )

def nb_test(name, srcs, deps = [], **kwargs):
    """Notebook test. Execute notebooks as a test.

    Args:
        name: Name for test_suite
        srcs: Notebooks to run as tests. Sequential execution of notebooks in list.
        deps: Dependencies to use for the test.
        **kwargs: arguments for py_test intermediate targets
    """
    py_test(
        name = name,
        main = "notebook_bin.py",
        srcs = ["//tools/notebook:notebook_bin.py"],
        args = ["$(location " + src + ")" for src in srcs],
        data = srcs,
        deps = [
            # Add papermill and ipykernel as deps
            requirement("papermill"),
            requirement("ipykernel"),
        ] + deps,
        **kwargs
    )

def nb_test_suite(name, srcs, deps = [], visibility = None, **kwargs):
    """Notebook test suite. Test each notebook in list as an individual nb_test and join as a test_suite. 

    This target has improved parallelism over using nb_test.

    Args:
        name: Name for test_suite
        srcs: Notebooks to run as tests.
        deps: Dependencies to use for the test.
        visibility: Test suite visibility.
        **kwargs: arguments for py_test intermediate targets
    """
    tests = []
    for src in srcs:
        test_name = src.replace(".ipynb", "__nbtest")
        tests.append(test_name)
        nb_test(
            name = test_name,
            srcs = [src],
            deps = deps,
            visibility = ["//visibility:private"],
            **kwargs
        )

    native.test_suite(
        name = name,
        tests = tests,
        visibility = visibility,
    )
