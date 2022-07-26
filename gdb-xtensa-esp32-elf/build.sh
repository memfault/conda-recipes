#!/bin/bash

set -ex

TARGET=xtensa-esp32-elf

# Copy everything into a TARGET-namespaced directory. This is so we don't
# overwrite other GDB versions' bin/lib/include/share etc. files, which might
# not be target-prefixed!
mkdir -p "${PREFIX}/${TARGET}"
cp -r ${SRC_DIR}/* "${PREFIX}/${TARGET}"

# Symlink the binaries into the PREFIX/bin directory so they're available on
# PATH
(
    # cd so we can use relative paths + wildcard for the symlink
    cd "${PREFIX}/bin"
    ln -s ../"${TARGET}"/bin/* ./
)
