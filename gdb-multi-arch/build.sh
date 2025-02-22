#!/bin/bash

# We keep arm-elf-linux here so that the order in which GDB attempts
#  to match the architecture is consistent between hosts.
# We'll rename the binaries later in the script
export FAKE_TARGET=arm-elf-linux
export REAL_TARGET=multi-arch

export FAKE_TARGET_PREFIX="${PREFIX}/${FAKE_TARGET}"
export REAL_TARGET_PREFIX="${PREFIX}/${REAL_TARGET}"

export CPPFLAGS="$CPPFLAGS -fcommon -I$PREFIX/include -Wno-constant-logical-operand"
export CFLAGS="$CFLAGS -Wno-constant-logical-operand -Wno-format-nonliteral -Wno-self-assign"

if [ `uname` == Darwin ]; then
  EXTRA_CONFIGURE_FLAGS=""
else
  EXTRA_CONFIGURE_FLAGS="--with-debuginfod"
fi

# Setting /usr/lib/debug as debug dir makes it possible to debug the system's
# python on most Linux distributions
./configure \
    --prefix="$FAKE_TARGET_PREFIX" \
    --target="$FAKE_TARGET" \
    --enable-targets=all \
    --with-separate-debug-dir="${FAKE_TARGET_PREFIX}/lib/debug:/usr/lib/debug" \
    --with-lzma \
    --with-expat \
    --with-libexpat-prefix="$PREFIX" \
    --with-libiconv-prefix="$PREFIX" \
    --without-guile \
    --without-libunwind-ia64 \
    --with-zlib \
    --without-babeltrace \
    --with-python="$PREFIX" \
    $EXTRA_CONFIGURE_FLAGS \
    --disable-ld \
    --disable-gprof \
    --disable-gas \
    --disable-sim \
    --disable-gold \
    --enable-64-bit-bfd
make
make install

# Move from the fake to real directory
mv "${FAKE_TARGET_PREFIX}" "${REAL_TARGET_PREFIX}"

# Enable matching with ! (not) bash operator
shopt -s extglob

# Delete every binary except addr2line, gdb, gdb-add-index, objcopy, objdump, and size.
pushd "${REAL_TARGET_PREFIX}"/bin/
    rm !(arm-elf-linux-addr2line|arm-elf-linux-gdb|arm-elf-linux-gdb-add-index|arm-elf-linux-objdump|arm-elf-linux-objcopy|arm-elf-linux-size|arm-elf-linux-strings)
    mv arm-elf-linux-addr2line addr2line
    mv arm-elf-linux-gdb gdb
    mv arm-elf-linux-gdb-add-index gdb-add-index
    mv arm-elf-linux-objcopy objcopy
    mv arm-elf-linux-objdump objdump
    mv arm-elf-linux-size size
    mv arm-elf-linux-strings strings
    strip addr2line
    # strip gdb
    strip objdump
    strip objcopy
    strip size
    strip strings
popd


# Symlink every binary from the build into /bin
pushd "${PREFIX}"/bin
    ln -s "${REAL_TARGET_PREFIX}"/bin/* ./
popd
