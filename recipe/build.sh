#!/bin/bash

set -exuo pipefail

export CGO_ENABLED=0

echo "PKG_VERSION = ${PKG_VERSION}"

go mod vendor
go build \
    -trimpath \
    -mod vendor \
    -ldflags "-X github.com/databricks/cli/internal/build.buildVersion=${PKG_VERSION}" \
    -o "${BINARY_FILEPATH}"


# save thirdparty licenses
# FIXME: go-localreader caused go-licenses to fail, only on Windows
mkdir ./thirdparty
go-licenses save . --save_path ./thirdparty --ignore github.com/databricks/cli --ignore github.com/mattn/go-localereader
curl -fsSL -o ./thirdparty/mattn-go-localereader.txt https://raw.githubusercontent.com/mattn/go-localereader/refs/heads/master/LICENSE

# Clear out cache to avoid file not removable warnings
chmod -R u+w $(go env GOPATH) && rm -r $(go env GOPATH)
