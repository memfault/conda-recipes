#!/bin/bash

# We keep arm-elf-linux here so that the order in which GDB attempts
#  to match the architecture is consistent between hosts.
# We'll rename the binaries later in the script
export FAKE_TARGET=arm-elf-linux
export REAL_TARGET=multi-arch

export FAKE_TARGET_PREFIX="${PREFIX}/${FAKE_TARGET}"
export REAL_TARGET_PREFIX="${PREFIX}/${REAL_TARGET}"

export CPPFLAGS="$CPPFLAGS -fcommon -I$PREFIX/include -Wno-constant-logical-operand -ggdb"
export CFLAGS="$CFLAGS -Wno-constant-logical-operand -Wno-format-nonliteral -Wno-self-assign -ggdb"
export CXXFLAGS="$CXXFLAGS -ggdb"
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
    --disable-ld \
    --disable-gprof \
    --disable-gas \
    --disable-sim \
    --disable-gold
make
make install

# At this point the gdb file will be located at 
#   ../work/gdb/gdb
# So you can debug it with:
#   $ cd $HOME/mambaforge/envs/build/conda-bld/multi-arch-gdb_1658520479521/work/gdb/
#   $ /usr/local/bin/gdb --args ./gdb $HOME/dev/memfault/memfault/tools/tests/fixtures/binaries/symbols/heap-analyzer-example.elf
exit 1

