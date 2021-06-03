package(default_visibility = ["//visibility:public"])

licenses(["notice"])

exports_files(["notebook_bin.py"])

py_binary(
    name = "nb_lib_convert",
    srcs = ["notebook_lib.py"],
    main = "notebook_lib.py",
    deps = [
        requirement("nbconvert"),
        requirement("ipython"),
    ],
)
