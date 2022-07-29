#!/usr/bin/env bash

go build

mkdir -p $PREFIX/bin
cp $SRC_DIR/terraform $PREFIX/bin
