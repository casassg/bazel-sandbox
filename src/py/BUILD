load("@io_bazel_rules_docker//python3:image.bzl", "py3_image")
load("@io_bazel_rules_docker//container:container.bzl", "container_image")
load("//tools/container:copy_layer.bzl", "copy_layer")

package(default_visibility = ["//visibility:public"])

licenses(["notice"])

py_library(
    name = "lib",
    srcs = glob(["lib/*.py"]),
    imports = ["."],
)

py_binary(
    name = "main",
    srcs = ["main.py"],
    deps = [
        "//src/nb:nb_lib",
        "//src/py:lib",
        requirement("tensorflow"),
    ],
)

# This allows us to perform multi-stage builds with Beam
# Equivalent to Docker command:  `COPY --from=apache/beam_python3.7_sdk:2.35.0 /opt/apache/beam /opt/apache/beam`
copy_layer(
    name = "beam_layer",
    image = "@beam//image",
    path = "/opt/apache/beam",
    dest_path = "/opt/apache/beam"
)

container_image(
    name = "py_base",
    base = "@python37//image",
    layers = [":beam_layer"],
    symlinks = {
        "/usr/bin/python": "/usr/bin/python3",
    },
)

py3_image(
    name = "py_image",
    srcs = ["main.py"],
    base = ":py_base",
    main = "main.py",
    deps = [
        "//src/nb:nb_lib",
        "//src/py:lib",
        requirement("tensorflow"),
    ],
)
