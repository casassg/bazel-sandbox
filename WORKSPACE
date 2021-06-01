workspace(name = "bazel_sandbox")





# ToDo(gcasassaez): Revert this as soon as new release is done for rules_python.
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
rules_python_version = "ed6cc8f2c3692a6a7f013ff8bc185ba77eb9b4d2"  # Latest master commit for the moment so I can use `compile_pip_requirements`

http_archive(
    name = "rules_python",
    sha256 = "3cebd7e9e4bbd255e21538ff231680a8633a15c4ce43662899453b150bf315c1",
    strip_prefix = "rules_python-{version}".format(version = rules_python_version),
    url = "https://github.com/bazelbuild/rules_python/archive/{version}.tar.gz".format(version = rules_python_version),
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