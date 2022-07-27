#!/usr/bin/env bash

set -ex

TARGET=xtensa-esp32-elf

# Copy everything into a TARGET-namespaced directory. This is so we don't
# overwrite other GDB versions' bin/lib/include/share etc. files, which might
# not be target-prefixed!
export TARGET=xtensa-esp32-elf
export TARGET_PREFIX="${PREFIX}/${TARGET}"

mkdir -p "${PREFIX}"/bin
mkdir -p "${TARGET_PREFIX}"/bin

# Only copy what is necessary or else we'll copy a bunch of internal Conda stuff.

# Wrapper scripts for esp32* variants
cp "$SRC_DIR"/xtensa-esp32*-elf-gdb            "$TARGET_PREFIX"/bin/
chmod +x "$TARGET_PREFIX"/bin/*
# This is the actual, python-version-specific gdb binary.
cp "$SRC_DIR"/bin/xtensa-esp-elf-gdb-${PY_VER} "$TARGET_PREFIX"/bin/xtensa-esp-elf-gdb
cp --recursive "$SRC_DIR"/include              "$TARGET_PREFIX"
cp --recursive "$SRC_DIR"/lib                  "$TARGET_PREFIX"
cp --recursive "$SRC_DIR"/share                "$TARGET_PREFIX"

# Symlink every binary from the build into /bin
(
    # cd so we can use relative paths + wildcard for the symlink
    cd "${PREFIX}/bin"
    ln -s ../"${TARGET}"/bin/* ./
)
