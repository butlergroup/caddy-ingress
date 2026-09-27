#!/bin/bash
set -e

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

echo "Verifying modules..."
go mod verify
