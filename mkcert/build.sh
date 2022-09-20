#!/usr/bin/env bash

go build -ldflags "-X main.Version=${PKG_VERSION}" -o "${PREFIX}/bin/mkcert"
