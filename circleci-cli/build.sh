#!/usr/bin/env bash

# get us a go compiler
export PATH=$PATH:$SRC_DIR/gocompiler/bin

make

# the output binary is located at ex: 'build/linux/amd64/circleci'
mkdir -p $PREFIX/bin
cp $SRC_DIR/build/*/*/circleci $PREFIX/bin
