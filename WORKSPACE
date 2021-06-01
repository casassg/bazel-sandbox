workspace(name = "bazel_sandbox")




# Load rules_python from git to get compile_pip_requirements target. 
# ToDo(gcasassaez): Revert this as soon as new release is done.
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
git_repository(
    name="rules_python",
    remote="https://github.com/bazelbuild/rules_python",
    commit="c6970fc44877dbbbce84d17845d9bc797aefe299",
    shallow_since = "1621986152 +1000",
)
# load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
# http_archive(
#     name = "rules_python",
#     url = "https://github.com/bazelbuild/rules_python/releases/download/0.2.0/rules_python-0.2.0.tar.gz",
#     sha256 = "778197e26c5fbeb07ac2a2c5ae405b30f6cb7ad1f5510ea6fdac03bded96cc6f",
# )

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