#!/ust/bin/env bash

mkdir -p "${PREFIX}/bin"

echo "#!/usr/bin/env bash\nXTENSA_GNU_CONFIG=xtensa_esp8266.so xtensa-esp-elf-gdb-${PY_VER} \"\$@\"" > "${PREFIX}"/bin/xtensa-lx106-elf-gdb
chmod +x "${PREFIX}"/bin/xtensa-lx106-elf-gdb
#echo "XTENSA_GNU_CONFIG=xtensa_esp8266.so xtensa-esp-elf-gdb-${PY_VER} \"\$@\"" > "${SRC_DIR}"/xtensa-lx106-elf-gdb-test
#echo "${PREFIX}"/bin/xtensa-lx106-elf-gdb > "${SRC_DIR}"/xtensa-lx106-elf-gdb-meta
#chmod +x "${SRC_DIR}"/xtensa-lx106-elf-gdb-test

#exit 1

cp -R "${SRC_DIR}"/bin/xtensa-esp32*-elf-gdb "${PREFIX}"/bin
cp -R "${SRC_DIR}/bin/xtensa-esp-elf-gdb-${PY_VER}" "${PREFIX}"/bin
cp -R "${SRC_DIR}"/lib "${PREFIX}"
cp -R "${SRC_DIR}"/share "${PREFIX}"
