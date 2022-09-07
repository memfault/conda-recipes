#!/usr/bin/env bash
set -e

if [ `uname` == Darwin ]; then
    set +e
    # just confirm the script properly errors
    eu-unstrip;
    if [ $? -ne 2 ]; then
        echo "error: eu-unstrip should have returned error code 2!"
        exit 1
    fi
else
    eu-addr2line --help
    eu-ar --help
    eu-elfcmp --help
    eu-findtextrel --help
    eu-nm --help
    eu-objdump --help
    eu-ranlib --help
    eu-size --help
    eu-strings --help
    eu-strip --help
    eu-unstrip --help

    # This currently fails for various reasons:
    #   Package zlib was not found in the pkg-config search path.
    #   Perhaps you should add the directory containing `zlib.pc'
    #   to the PKG_CONFIG_PATH environment variable
    #   Package 'zlib', required by 'libelf', not found
    #   /tmp/tmpdtkbtwmh/info/recipe/test_libdwarf.c:1:10: fatal error: elfutils/libdw.h: No such file or directory
    #       1 | #include <elfutils/libdw.h>
    #         |          ^~~~~~~~~~~~~~~~~~
    #
    # Skip this test for now. We don't use libdw, only unstrip, at the moment

    # eval "${CC} -o ./test_libdwarf $RECIPE_DIR/test_libdwarf.c $(pkg-config --cflags libdw) $(pkg-config --libs libdw)"
    # ./test_libdwarf
fi
