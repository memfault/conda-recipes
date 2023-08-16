#!/bin/usr/env bash

# Installation directory for the toolchain is 'xtensa-esp32-elf' to distinguish
# from esp8266 etc.
export TARGET_DIR=xtensa-esp32-elf
export TARGET_PREFIX="${PREFIX}/${TARGET_DIR}"

mkdir -p "${TARGET_PREFIX}/bin"

# Only install the gdb bin variant for the target python version
cp "${SRC_DIR}/bin/xtensa-esp-elf-gdb-${PY_VER}" "${TARGET_PREFIX}/bin/xtensa-esp-elf-gdb"

# Selectively copy the rest of the bin files
_bins=(
  xtensa-esp-elf-gdb-add-index
  xtensa-esp-elf-gprof
)
for _bin in "${_bins[@]}"; do
  cp "${SRC_DIR}/bin/${_bin}" "${TARGET_PREFIX}/bin"
done

# Copy the rest of the files
shopt -s extglob
cp -r "${SRC_DIR}/"!(bin) "${TARGET_PREFIX}"

# Install our custom esp32-variant-specific (esp32s2 etc) wrappers, which don't
# have the python detection logic but just pass args through
cp "${RECIPE_DIR}"/xtensa-esp32*-elf-gdb "${TARGET_PREFIX}"/bin/
chmod +x "${TARGET_PREFIX}"/bin/*

# Symlink every binary from the build into /bin
(
  cd "${PREFIX}"/bin
  ln -s ../"${TARGET_DIR}"/bin/* ./
)

# Same for lib
(
  cd "${PREFIX}"/lib
  ln -s ../"${TARGET_DIR}"/lib/* ./
)
