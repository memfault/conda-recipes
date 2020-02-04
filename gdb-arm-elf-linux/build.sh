#!/bin/bash

export TARGET=arm-elf-linux
export TARGET_PREFIX="${PREFIX}/${TARGET}"

export CPPFLAGS="$CPPFLAGS -I$PREFIX/include"
# Setting /usr/lib/debug as debug dir makes it possible to debug the system's
# python on most Linux distributions
./configure \
    --prefix="${TARGET_PREFIX}" \
    --target="$TARGET" \
    --with-separate-debug-dir="${TARGET_PREFIX}/lib/debug:/usr/lib/debug" \
    --with-lzma \
    --with-expat \
    --with-libexpat-prefix="$PREFIX" \
    --with-libiconv-prefix="$PREFIX" \
    --without-libunwind-ia64 \
    --with-zlib \
    --without-babeltrace \
    --with-python \
    --disable-ld \
    --disable-gprof \
    --disable-gas
make
make install


shopt -s extglob 

# Delete every binary except addr2line, gdb, gdb-add-index, objdump, and size.
pushd "${TARGET_PREFIX}"/bin/
    rm !(arm-elf-linux-addr2line|arm-elf-linux-gdb|arm-elf-linux-gdb-add-index|arm-elf-linux-objdump|arm-elf-linux-size|arm-elf-linux-strings)
    strip arm-elf-linux-addr2line
    strip arm-elf-linux-gdb
    strip arm-elf-linux-objdump
    strip arm-elf-linux-size
    strip arm-elf-linux-strings
popd


# Symlink every binary from the build into /bin
pushd "${PREFIX}"/bin
    ln -s "${TARGET_PREFIX}"/bin/* ./
popd
