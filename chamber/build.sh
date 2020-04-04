#!/bin/bash

mkdir $PREFIX/bin
cp $SRC_DIR/chamber* $PREFIX/bin
mv $PREFIX/bin/chamber* $PREFIX/bin/chamber
chmod +x $PREFIX/bin/chamber
