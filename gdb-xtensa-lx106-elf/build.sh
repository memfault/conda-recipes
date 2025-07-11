#!/ust/bin/env bash

mkdir -p "${PREFIX}/bin"

cp -R "${SRC_DIR}"/bin/xtensa-lx106*-elf-gdb "${PREFIX}"/bin
cp -R "${SRC_DIR}/bin/xtensa-esp-elf-gdb-${PY_VER}" "${PREFIX}"/bin
cp -R "${SRC_DIR}"/lib "${PREFIX}"
cp -R "${SRC_DIR}"/share "${PREFIX}"

