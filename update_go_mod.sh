#!/bin/bash

set -euo pipefail

PINNED=(
    "github.com/KimMachineGun/automemlimit@v0.7.5"
    "k8s.io/kube-openapi@v0.0.0-20260821135717-be32def86098"
)

echo "Updating all dependencies..."

go get -u ./...

echo "Restoring pinned dependencies..."

for dependency in "${PINNED[@]}"; do
    go get "$dependency"
done

echo "Cleaning graph..."

go mod tidy

echo "Verifying pinned dependencies..."

for dependency in "${PINNED[@]}"; do
    module="${dependency%@*}"
    version="${dependency#*@}"

    actual=$(go list -m -f '{{.Version}}' "$module")

    if [[ "$actual" != "$version" ]]; then
        echo "ERROR: $module is $actual, expected $version"
        exit 1
    fi

    echo "OK: $module@$actual"
done

echo "Verifying modules..."

go mod verify

echo "Dependency update complete."