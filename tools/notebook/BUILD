package(default_visibility = ["//visibility:public"])

licenses(["notice"])

exports_files(["notebook_bin.py"])

py_binary(
    name='nb_lib_convert',
    main='notebook_lib.py',
    srcs=['notebook_lib.py'],
    deps=[
      requirement('nbconvert'),
    ]
  )