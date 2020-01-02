#!/bin/bash

# Copy the [de]activate scripts to $PREFIX/etc/conda/[de]activate.d.
# This will allow them to be run on environment activation.
for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
done


cd $SRC_DIR

# Alternative to CMake to build the project
./autogen.sh
mkdir tmp_build && cd tmp_build/
../configure --disable-dependency-tracking --prefix="$PREFIX"
make
make check
make install
