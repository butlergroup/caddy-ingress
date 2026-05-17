#!/usr/bin/env bash

set -euo pipefail

REPO="butlergroup/caddy-ingress"
CHART="oci://ghcr.io/butlergroup/charts/caddy-ingress-controller"

echo "Discovering latest release..."

LATEST_TAG=$(curl -fsSL \
  "https://api.github.com/repos/${REPO}/releases/latest" \
  | grep '"tag_name":' \
  | sed -E 's/.*"([^"]+)".*/\1/')

if [[ -z "${LATEST_TAG}" ]]; then
  echo "Failed to determine latest release"
  exit 1
fi

echo "Latest release: ${LATEST_TAG}"

# Convert app tag to chart version if needed
# Example:
# v0.4.78 -> 1.5.78

CHART_VERSION=$(echo "${LATEST_TAG}" \
  | sed 's/^v0\.4\./1.5./')

echo "Resolved chart version: ${CHART_VERSION}"

echo "Installing/upgrading Helm chart..."

helm upgrade --install caddy-ingress \
  "${CHART}" \
  --version "${CHART_VERSION}" \
  "$@"

echo "Done."