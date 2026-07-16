#!/bin/bash

set -exuo pipefail

export CGO_ENABLED=0

echo "PKG_VERSION = ${PKG_VERSION}"

IFS=. read -r VERSION_MAJOR VERSION_MINOR VERSION_PATCH <<< "${PKG_VERSION}"

# stamp semver metadata; the Databricks Python SDK feature-gates on it and treats 0.0.0 as a dev build
go mod vendor
go build \
    -trimpath \
    -mod vendor \
    -ldflags "\
-X github.com/databricks/cli/internal/build.buildVersion=${PKG_VERSION} \
-X github.com/databricks/cli/internal/build.buildMajor=${VERSION_MAJOR} \
-X github.com/databricks/cli/internal/build.buildMinor=${VERSION_MINOR} \
-X github.com/databricks/cli/internal/build.buildPatch=${VERSION_PATCH} \
-X github.com/databricks/cli/internal/build.buildSummary=v${PKG_VERSION}" \
    -o "${BINARY_FILEPATH}"


# save thirdparty licenses
go-licenses save . --save_path ./thirdparty --ignore github.com/databricks/cli

# Clear out cache to avoid file not removable warnings
chmod -R u+w $(go env GOPATH) && rm -r $(go env GOPATH)
