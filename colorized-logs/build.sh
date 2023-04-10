#!/usr/bin/env bash
cmake -B build -DCMAKE_INSTALL_PREFIX=$PREFIX
cmake --build build --target install
