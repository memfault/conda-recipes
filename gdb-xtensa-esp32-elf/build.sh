#!/usr/bin/env bash

mkdir -p "${PREFIX}/bin"

cp -R "${SRC_DIR}"/bin/xtensa-esp32*-elf-gdb "${PREFIX}"/bin
cp -R "${SRC_DIR}/bin/xtensa-esp-elf-gdb-${PY_VER}" "${PREFIX}"/bin
cp -R "${SRC_DIR}"/lib "${PREFIX}"
cp -R "${SRC_DIR}"/share "${PREFIX}"

PROXY_SCRIPT_NAME="${PREFIX}/bin/xtensa-lx106-elf-gdb"

printf "#!/usr/bin/env bash\nexec env XTENSA_GNU_CONFIG=xtensa_esp8266.so xtensa-esp-elf-gdb-%s \"\$@\"" "${PY_VER}" > "${PROXY_SCRIPT_NAME}"
chmod +x "${PROXY_SCRIPT_NAME}"
