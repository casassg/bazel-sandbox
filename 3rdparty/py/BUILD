load("@rules_python//python/pip_install:requirements.bzl", "compile_pip_requirements")

package(default_visibility = ["//visibility:public"])

licenses(["notice"])


compile_pip_requirements(
    name = "requirements",
    extra_args = ["--allow-unsafe"],
)