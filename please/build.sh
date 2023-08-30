#!/usr/bin/env bash
# See https://get.please.build/ script for more details.

mkdir $PREFIX/bin

cp $SRC_DIR/please $PREFIX/bin/plz

chmod +x $PREFIX/bin/plz
