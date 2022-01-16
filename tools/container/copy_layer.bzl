"""Copy layer rule"""

load("@io_bazel_rules_docker//container:container.bzl", "container_flatten", "container_layer")

def copy_layer(name, image, path, dest_path = "", visibility = None, **kwargs):
    """Creates layer from contents of another image under specified path. 
    
    This is similar to Docker multi-stage COPY command.

        COPY --from=apache/beam_java8_sdk:2.35.0 /opt/apache/beam /opt/apache/beam


    Args:
      name: Name for the copied layer
      image: Image to copy files from (--from).
      path: Path to copy from image.
      dest_path: Destination path for the copied files.
      visibility: Visibility for library.
      **kwargs: args for container_rule
    """

    if not path.startswith("/"):
        fail("Path to copy must be absolute, found {} instead".format(path))
    if dest_path and not dest_path.startswith("/"):
        fail("Destination path for files must be absolute, found {} instead".format(dest_path))

    flat_name = "{}.flat".format(name)
    container_flatten(
        image = image,
        name = "{}.flat".format(name),
        visibility = ["//visibility:private"],
    )
    outs = [
        "{}.tar".format(name),
    ]
    cmd = "$(location //tools/container:extract_files) --tar $(SRCS)  --out $(OUTS) --path {path} ".format(path = path)
    if dest_path:
        cmd += "--dest_path {dest_path}".format(dest_path = dest_path)
    native.genrule(
        name = "{}.extract".format(name),
        srcs = ["{}.tar".format(flat_name)],
        outs = outs,
        cmd = cmd,
        tools = ["//tools/container:extract_files"],
        visibility = ["//visibility:private"],
    )
    container_layer(tars = outs, name = name, visibility = visibility, **kwargs)
