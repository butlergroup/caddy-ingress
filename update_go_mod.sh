#!/bin/bash
set -e

echo "Updating all dependencies..."

go get -u ./...

echo "Cleaning graph..."
go mod tidy

echo "Verifying modules..."
go mod verify
