#!/bin/usr/env bash

mkdir "${PREFIX}/bin"
mkdir "${PREFIX}/lib"

cp -r "${SRC_DIR}/bin" "${SRC_DIR}/lib" "${PREFIX}"
