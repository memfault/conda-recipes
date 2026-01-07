#!/bin/usr/env bash

###
# Note
#
# This script is partially based on:
# https://github.com/espressif/binutils-gdb/blob/esp-gdb-v11.1_20220318/build_esp_gdb.sh
# and
# https://github.com/espressif/binutils-gdb/blob/esp-gdb-16.2/build_esp_gdb.sh
###

# The tool name should be 'xtensa-esp-elf', the same as how Espressif names it
export TARGET=xtensa-esp-elf
# Installation directory for the toolchain is 'xtensa-esp32-elf' to distinguish
# from esp8266 etc.
export TARGET_DIR=xtensa-esp32-elf
export TARGET_PREFIX="${PREFIX}/${TARGET_DIR}"

export CPPFLAGS="$CPPFLAGS -I$PREFIX/include"
# Setting /usr/lib/debug as debug dir makes it possible to debug the system's
# python on most Linux distributions

export ESP_CHIP_ARCHITECTURE=xtensa
export GDB_DIST="$PWD"/dist
GDB_REPO_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Disable PLATFORM selection for the xtensaconfig build. This disables the bin-wrapper script from being
# included in the xtensaconfig output. We don't really want it- it's used to at
# runtime check if python is available, but since this is a conda package, in a
# healthy compatible environment, it will be.
PLATFORM=

# Clear the PREFIX variable temporarily so the xtensa-config lib install works
# correctly:
# https://github.com/espressif/esp-xtensaconfig-lib/blob/5db415200f750f871b40b2ef5860d3d01275ae8b/Makefile#L83-L84
_PREFIX=${PREFIX}
unset PREFIX

# Build xtensa-config libs
mkdir -p "${GDB_DIST}"/lib
pushd xtensa-dynconfig || exit 1
make clean
make CONF_DIR="${GDB_REPO_ROOT}/xtensa-overlays"
# AR="$TARGET_HOST-ar" CC="$TARGET_HOST-gcc"
if [ -z "$MACOSX_DEPLOYMENT_TARGET" ]; then
  TARGET_ESP_ARCH=xtensa DESTDIR="${GDB_DIST}" PLATFORM=$PLATFORM make install
else
  TARGET_ESP_ARCH=xtensa DESTDIR="${GDB_DIST}" PLATFORM=$PLATFORM make install CFLAGS="-Wl,-L,$(xcode-select -p)/SDKs/MacOSX.sdk/usr/lib -Wl,-lSystem"
fi
popd || exit 1
# Install xtensa-config libs
mkdir -p "$TARGET_PREFIX"/lib
cp -R "${GDB_DIST}"/lib "$TARGET_PREFIX"/

# Build wrappers
pushd esp-toolchain-bin-wrappers/gnu-debugger/unix || exit 1
if [ -z "$MACOSX_DEPLOYMENT_TARGET" ]; then
  RUST_TARGET_TRIPLET="x86_64-unknown-linux-gnu"
else
  RUST_TARGET_TRIPLET="aarch64-apple-darwin"
fi
rustup target add "$RUST_TARGET_TRIPLET"
cargo install --target=$RUST_TARGET_TRIPLET --no-track --path ./ --root $GDB_DIST
popd || exit 1

# Restore PREFIX variable
PREFIX=${_PREFIX}

if [ "$(uname)" == "Darwin" ]; then
  EXTRA_CONFIGURE_FLAGS=""
else
  EXTRA_CONFIGURE_FLAGS="--with-debuginfod"
fi

# Configure, build, and install gdb
./configure \
    --prefix="${TARGET_PREFIX}" \
    --target=$TARGET \
    --with-separate-debug-dir="${TARGET_PREFIX}/lib/debug:/usr/lib/debug" \
    --with-lzma \
    --with-expat \
    --with-libexpat-prefix="$PREFIX" \
    --with-libiconv-prefix="$PREFIX" \
    --with-libexpat-type=static \
    --with-libgmp-type=static \
    --with-static-standard-libraries \
    --without-libunwind-ia64 \
    --with-zlib \
    --without-babeltrace \
    --with-python="$PREFIX" \
    $EXTRA_CONFIGURE_FLAGS \
    --disable-threads \
    --disable-sim \
    --disable-nls \
    --disable-binutils \
    --disable-ld \
    --disable-gas \
    --without-guile \
    --disable-sim \
    --disable-gold \
    --with-pkgversion="esp-gdb" \
    --with-xtensaconfig
make -j${CPU_COUNT}
make install

mkdir -p "$TARGET_PREFIX"/bin/

echo "Renaming things..."
# rename gdb to have python version in filename
mv ${TARGET_PREFIX}/bin/xtensa-esp-elf-gdb ${TARGET_PREFIX}/bin/xtensa-esp-elf-gdb-${PY_VER}

# Wrapper scripts for esp32* variants
# Set up the wrappers
cp $GDB_DIST/bin/esp-elf-gdb-wrapper $TARGET_PREFIX/bin/xtensa-esp32-elf-gdb 2> /dev/null || true
cp $GDB_DIST/bin/esp-elf-gdb-wrapper $TARGET_PREFIX/bin/xtensa-esp32s2-elf-gdb 2> /dev/null || true
mv $GDB_DIST/bin/esp-elf-gdb-wrapper $TARGET_PREFIX/bin/xtensa-esp32s3-elf-gdb 2> /dev/null || true
chmod +x "$TARGET_PREFIX"/bin/*

# Symlink every binary from the build into /bin
pushd "${PREFIX}"/bin || exit 1
    ln -s ../"${TARGET_DIR}"/bin/* ./
popd || exit 1

# Same for lib
pushd "${PREFIX}"/lib || exit 1
    ln -s ../"${TARGET_DIR}"/lib/* ./
popd || exit 1
