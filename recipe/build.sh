#!/bin/bash

set -exuo pipefail

export CGO_ENABLED=0

echo "PKG_VERSION = ${PKG_VERSION}"

go mod vendor
go build \
    -trimpath \
    -mod vendor \
    -ldflags "-X github.com/databricks/cli/internal/build.buildVersion=${PKG_VERSION}" \
    -o "${PREFIX}/bin/databricks"


# save thirdparty licenses
go-licenses save . --save_path ./thirdparty --ignore github.com/databricks/cli

# Clear out cache to avoid file not removable warnings
chmod -R u+w $(go env GOPATH) && rm -r $(go env GOPATH)
