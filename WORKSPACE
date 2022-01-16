workspace(name = "bazel_sandbox")


load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# ToDo(gcasassaez): Revert this as soon as new release is done for rules_python.
rules_python_version = "ed6cc8f2c3692a6a7f013ff8bc185ba77eb9b4d2"  # Latest master commit for the moment so I can use `compile_pip_requirements`
http_archive(
    name = "rules_python",
    sha256 = "3cebd7e9e4bbd255e21538ff231680a8633a15c4ce43662899453b150bf315c1",
    strip_prefix = "rules_python-{version}".format(version = rules_python_version),
    url = "https://github.com/bazelbuild/rules_python/archive/{version}.tar.gz".format(version = rules_python_version),
)

http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "59536e6ae64359b716ba9c46c39183403b01eabfbd57578e84398b4829ca499a",
    strip_prefix = "rules_docker-0.22.0",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.22.0/rules_docker-v0.22.0.tar.gz"],
)


load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)
container_repositories()


load(
    "@io_bazel_rules_docker//python3:image.bzl",
    _py_image_repos = "repositories",
)

_py_image_repos()

load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")

container_deps()

load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_pull",
)

container_pull(
    name = "python37",
    repository = "python",
    registry = "index.docker.io",
    # tag = "3.7",
    digest = "sha256:3908249ce6b2d28284e3610b07bf406c3035bc2e3ce328711a2b42e1c5a75fc1",
)

container_pull(
    name = "beam",
    repository = "apache/beam_python3.7_sdk",
    registry = "index.docker.io",
    # tag = "2.25.0", 
    digest = "sha256:0fe31a7f5e6df3bcbf793b24ef893163ad7e9fadbeae2b304ce9aae8b0348b97",
)


load("@rules_python//python:pip.bzl", "pip_parse")

# Create a central repo that knows about the dependencies needed from
# requirements_lock.txt.
pip_parse(
   name = "my_deps",
   requirements_lock = "//3rdparty/py:requirements.txt",
)

# Load the starlark macro which will define your dependencies.
load("@my_deps//:requirements.bzl", "install_deps")
# Call it to define repos for your requirements.
install_deps()