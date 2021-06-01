load("@rules_python//python/pip_install:requirements.bzl", "compile_pip_requirements")

package(default_visibility = ["//visibility:public"])

licenses(["notice"])

# Update with bazel run //3rdparty/py:requirements.update
compile_pip_requirements(
    name = "requirements",
    extra_args = ["--allow-unsafe"],
)