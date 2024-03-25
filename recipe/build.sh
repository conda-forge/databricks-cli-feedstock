#!/bin/bash

set -exuo pipefail

export CGO_ENABLED=0

go mod vendor
go build \
    -trimpath \
    -mod vendor \
    -ldflags "-X github.com/databricks/cli/internal/build.buildVersion={{ version }}" \
    -o "${PREFIX}/bin/databricks"


# save thirdparty licenses
go-licenses save . --save_path ./thirdparty --ignore github.com/databricks/cli

tree -d ./thirdparty


# Clear out cache to avoid file not removable warnings
chmod -R u+w $(go env GOPATH) && rm -r $(go env GOPATH)
