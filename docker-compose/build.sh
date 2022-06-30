#!/bin/bash

mkdir $PREFIX/bin
cp $SRC_DIR/docker-compose* $PREFIX/bin
mv $PREFIX/bin/docker-compose* $PREFIX/bin/docker-compose
chmod +x $PREFIX/bin/docker-compose
