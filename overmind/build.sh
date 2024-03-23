#!/usr/bin/env bash

mkdir $PREFIX/bin

gunzip -c $SRC_DIR/overmind*.gz > $PREFIX/bin/overmind

chmod +x $PREFIX/bin/overmind
