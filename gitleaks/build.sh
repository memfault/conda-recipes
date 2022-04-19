#!/usr/bin/env bash

mkdir $PREFIX/bin

cp $SRC_DIR/gitleaks* $PREFIX/bin/gitleaks

chmod +x $PREFIX/bin/gitleaks
