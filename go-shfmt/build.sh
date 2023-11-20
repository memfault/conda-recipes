#!/usr/bin/env bash

CGO_ENABLED=0 go build -trimpath -ldflags="-w -s -X=main.version=v${PKG_VERSION}" -o "${PREFIX}/bin/shfmt" ./cmd/shfmt
