#!/usr/bin/env bash

make

# the output binary is located at ex: 'build/linux/amd64/circleci'
mkdir -p $PREFIX/bin
cp $SRC_DIR/build/*/*/circleci $PREFIX/bin
