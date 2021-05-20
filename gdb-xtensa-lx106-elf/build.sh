#!/bin/bash

# Copy the ESP8266 "overlay" files:
cp -av $SRC_DIR/xtensa-overlays/xtensa_lx106/binutils/. $SRC_DIR/binutils-gdb-lx106-src/
cp -av $SRC_DIR/xtensa-overlays/xtensa_lx106/gdb/. $SRC_DIR/binutils-gdb-lx106-src/

export TARGET=xtensa-lx106-elf
export TARGET_PREFIX="${PREFIX}/${TARGET}"

export CPPFLAGS="$CPPFLAGS -I$PREFIX/include"
# Setting /usr/lib/debug as debug dir makes it possible to debug the system's
# python on most Linux distributions

cd binutils-gdb-lx106-src

./configure \
    --prefix="${TARGET_PREFIX}" \
    --target=$TARGET \
    --with-separate-debug-dir="${TARGET_PREFIX}/lib/debug:/usr/lib/debug" \
    --with-lzma \
    --with-expat \
    --with-libexpat-prefix="$PREFIX" \
    --with-libiconv-prefix="$PREFIX" \
    --without-libunwind-ia64 \
    --with-zlib \
    --without-babeltrace \
    --with-python="$PREFIX" \
    --disable-threads \
    --disable-sim \
    --disable-nls \
    --disable-binutils \
    --disable-ld \
    --disable-gas
make
make install

shopt -s extglob

# Delete every binary except gdb
pushd "${TARGET_PREFIX}"/bin/
    rm !(xtensa-lx106-elf-gdb)
    strip xtensa-lx106-elf-gdb
popd


# Symlink every binary from the build into /bin
pushd "${PREFIX}"/bin
    ln -s "${TARGET_PREFIX}"/bin/* ./
popd