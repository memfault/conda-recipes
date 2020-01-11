#!/bin/bash

export TARGET=arm-elf-linux

export CPPFLAGS="$CPPFLAGS -I$PREFIX/include"
# Setting /usr/lib/debug as debug dir makes it possible to debug the system's
# python on most Linux distributions
./configure \
    --prefix="$PREFIX" \
    --target=$TARGET \
    --with-separate-debug-dir="$PREFIX/lib/debug:/usr/lib/debug" \
    --with-lzma \
    --with-expat \
    --with-libexpat-prefix="$CONDA_PREFIX" \
    --without-libunwind-ia64 \
    --with-zlib \
    --without-babeltrace \
    --with-python \
    --disable-ld \
    --disable-gas
make
make install
