#!/bin/bash

export LDFLAGS_CONDA="${LDFLAGS} -Wl,-rpath,$PREFIX/lib -L$PREFIX/lib"

./install-sources.sh
./build-prerequisites.sh
./build-toolchain.sh --skip_steps=howto,manual

export TARGET=arm-none-eabi
export TARGET_PREFIX="${PREFIX}/${TARGET}"

mkdir -p "${PREFIX}"/bin
mkdir -p "${TARGET_PREFIX}"

cp -R install-native/* $TARGET_PREFIX

# Symlink every binary from the build into /bin
pushd "${PREFIX}"/bin
    ln -s ../"${TARGET}"/bin/* ./
popd
