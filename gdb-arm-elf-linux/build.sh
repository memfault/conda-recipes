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
    --disable-gas
make
make install

# Symlink every binary from the build into /bin
pushd "${PREFIX}"/bin
    ln -s ../"${TARGET}"/bin/* ./
popd