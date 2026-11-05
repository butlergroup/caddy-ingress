#!/bin/bash
set -e

echo "Updating all dependencies..."

go get -u ./...

echo "Restoring pinned dependencies..."

go get "k8s.io/kube-openapi@v0.0.0-20260821135717-be32def86098"
go get "github.com/quic-go/quic-go@v0.64.1"

echo "Cleaning graph..."
go mod tidy

echo "Verifying modules..."
go mod verify
