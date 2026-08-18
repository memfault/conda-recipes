#!/usr/bin/env bash

mkdir -p $PREFIX/bin
TARGET_BIN=$PREFIX/bin/clickhouse

OS=$(uname -s)
ARCH=$(uname -m)

# copy the binary into the installation target
if [ "${OS}" = "Linux" ]; then

  if [ "${ARCH}" = "x86_64" -o "${ARCH}" = "amd64" ]; then
    UPX_ARCH="amd64"
  elif [ "${ARCH}" = "aarch64" -o "${ARCH}" = "arm64" ]; then
    UPX_ARCH="arm64"
  fi

  cp $SRC_DIR/usr/bin/clickhouse $TARGET_BIN

  # the clickhouse binary is like 500MB on linux. let's pack it.
  wget https://github.com/upx/upx/releases/download/v5.1.1/upx-5.1.1-${UPX_ARCH}_linux.tar.xz
  tar -xf upx-5.1.1-${UPX_ARCH}_linux.tar.xz
  ./upx-5.1.1-${UPX_ARCH}_linux/upx $TARGET_BIN
elif [ "${OS}" = "Darwin" ]; then
  if [ "${ARCH}" = "x86_64" -o "${ARCH}" = "amd64" ]; then
    ARCH_SUFFIX=""
  elif [ "${ARCH}" = "aarch64" -o "${ARCH}" = "arm64" ]; then
    ARCH_SUFFIX="-aarch64"
  fi
  chmod +x $SRC_DIR/clickhouse-macos$ARCH_SUFFIX
  cp $SRC_DIR/clickhouse-macos$ARCH_SUFFIX $TARGET_BIN
fi
