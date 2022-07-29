#!/usr/bin/env bash

set -e

# activate the conda environment
source /opt/mambaforge/etc/profile.d/conda.sh
conda activate build

# run all args within the environment
$@
