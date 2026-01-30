#!/bin/bash

mkdir -p $PREFIX/bin
cp $SRC_DIR/aws-vault* $PREFIX/bin/aws-vault
chmod +x $PREFIX/bin/aws-vault
