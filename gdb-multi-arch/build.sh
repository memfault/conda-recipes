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
make -j${CPU_COUNT}
make install

# Move from the fake to real directory
mv "${FAKE_TARGET_PREFIX}" "${REAL_TARGET_PREFIX}"

# Enable matching with ! (not) bash operator
shopt -s extglob

# Delete most of the generated binaries like ld etc. Save gdb and its
# dependencies, and a few other very useful ones.
pushd "${REAL_TARGET_PREFIX}"/bin/
# array
bins_to_keep=(
  "addr2line"
  "gdb"
  "gdb-add-index"
  "objcopy"
  "objdump"
  "readelf"
  "size"
  "strings"
)
# prefix with the original target name prefix
prefix_bins_to_keep="${bins_to_keep[*]/#/${FAKE_TARGET}-}"
# get all non-matching globs (thanks to extglob), for deletion
antiglob="!(${prefix_bins_to_keep// /|})"
rm ${antiglob}

# Rename the binaries to the real target name prefix
for _x in "${bins_to_keep[@]}"; do
  mv "${FAKE_TARGET}-${_x}" "${REAL_TARGET}-${_x}"

  # don't strip "gdb-add-index", it's a shell script
  if [[ ! "${REAL_TARGET}-${_x}" =~ "gdb-add-index" ]]; then
    strip "${REAL_TARGET}-${_x}"
  fi
done
popd

# Symlink every binary from the build into /bin
pushd "${PREFIX}"/bin
ln -s "${REAL_TARGET_PREFIX}"/bin/* ./
popd
