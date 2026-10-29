#!/usr/bin/env bash

mkdir -p $PREFIX/bin
TARGET_BIN=$PREFIX/bin/clickhouse

OS=$(uname -s)
ARCH=$(uname -m)

# copy the binary into the installation target
if [ "${OS}" = "Linux" ]; then
  cp $SRC_DIR/usr/bin/clickhouse $TARGET_BIN
elif [ "${OS}" = "Darwin" ]; then
  if [ "${ARCH}" = "x86_64" -o "${ARCH}" = "amd64" ]; then
    ARCH_SUFFIX=""
  elif [ "${ARCH}" = "aarch64" -o "${ARCH}" = "arm64" ]; then
    ARCH_SUFFIX="-aarch64"
  fi
  chmod +x $SRC_DIR/clickhouse-macos$ARCH_SUFFIX
  cp $SRC_DIR/clickhouse-macos$ARCH_SUFFIX $TARGET_BIN
fi
