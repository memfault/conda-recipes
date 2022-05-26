#!/bin/bash

# Copy the ESP32 "overlay" files:
cp -av $SRC_DIR/crosstool-NG-esp32/overlays/xtensa_esp32/binutils/. $SRC_DIR/binutils-gdb-esp32-src/
cp -av $SRC_DIR/crosstool-NG-esp32/overlays/xtensa_esp32/gdb/. $SRC_DIR/binutils-gdb-esp32-src/

export TARGET=xtensa-esp32-elf
export TARGET_PREFIX="${PREFIX}/${TARGET}"

export CPPFLAGS="$CPPFLAGS -I$PREFIX/include"
# Setting /usr/lib/debug as debug dir makes it possible to debug the system's
# python on most Linux distributions

cd binutils-gdb-esp32-src

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
    --disable-gas \
    --disable-sim \
    --disable-gold
make
make install

# Symlink every binary from the build into /bin
pushd "${PREFIX}"/bin
    ln -s ../"${TARGET}"/bin/* ./
popd
