#!/bin/bash

mkdir $PREFIX/bin
cp $SRC_DIR/ecs-cli* $PREFIX/bin
mv $PREFIX/bin/ecs-cli* $PREFIX/bin/ecs-cli
chmod +x $PREFIX/bin/ecs-cli
