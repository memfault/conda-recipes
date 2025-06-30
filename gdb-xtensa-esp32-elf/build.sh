#!/ust/bin/env bash

#cp "$SRC_DIR"/xtensa-esp32*-elf-gdb "$PREFIX"/bin/

mkdir -p "${PREFIX}/bin"

cp -R "${SRC_DIR}"/bin/xtensa-esp32*-elf-gdb "${PREFIX}"/bin
cp -R "${SRC_DIR}/bin/xtensa-esp-elf-gdb-${PY_VER}" "${PREFIX}"/bin
cp -R "${SRC_DIR}"/lib "${PREFIX}"
cp -R "${SRC_DIR}"/share "${PREFIX}"
