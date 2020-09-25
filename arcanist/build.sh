#!/bin/bash

mkdir -p "${PREFIX}"/bin
mkdir -p "${PREFIX}"/share
cp -R $SRC_DIR/arcanist $PREFIX/share
cp -R $SRC_DIR/libphutil $PREFIX/share

# Symlink arc
pushd "${PREFIX}"/bin
    ln -s ../share/arcanist/bin/arc ./
popd
