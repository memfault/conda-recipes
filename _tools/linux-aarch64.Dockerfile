# Docker image for building linux-aarch64 packages from other hosts
#
# To enable using foreign architecture docker containers on a Linux host:
# ❯ sudo apt-get install qemu binfmt-support qemu-user-static # Install the qemu packages
# ❯ docker run --rm --privileged multiarch/qemu-user-static --reset -p yes # This step will execute the registering scripts
# From https://github.com/multiarch/qemu-user-static
#
# To use this image to build linux-aarch64 Conda packages:
#
# Example, build cpputest:
# 1. ❯ docker build -t conda-linux-aarch64 -f _tools/linux-aarch64.Dockerfile _tools
# 2. ❯ docker run --rm -i -t --volume "$PWD/cpputest":/recipe conda-linux-aarch64 mamba build -c conda-forge /recipe

# arm64/v8 from:
# https://hub.docker.com/layers/ubuntu/library/ubuntu/22.04/images/sha256-0f744430d9643a0ec647a4addcac14b1fbb11424be434165c15e2cc7269f70f8?context=explore
FROM ubuntu:22.04@sha256:0f744430d9643a0ec647a4addcac14b1fbb11424be434165c15e2cc7269f70f8

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    wget \
    && \
    update-ca-certificates

ARG MAMBA_VER=4.12.0-2

# install mambaforge
RUN wget --no-verbose https://github.com/conda-forge/miniforge/releases/download/${MAMBA_VER}/Mambaforge-${MAMBA_VER}-Linux-aarch64.sh \
    && bash Mambaforge-${MAMBA_VER}-Linux-aarch64.sh -b -p /opt/mambaforge \
    && rm Mambaforge-${MAMBA_VER}-Linux-aarch64.sh

# create 'build' conda environment and install conda-build
RUN . /opt/mambaforge/etc/profile.d/conda.sh \
    && conda create --name build conda-build==3.21.9

# entrypoint to run commands from within the conda environment
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
