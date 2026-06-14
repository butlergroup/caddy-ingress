#!/usr/bin/env bash

set -euo pipefail

CHART="oci://ghcr.io/butlergroup/caddy-ingress/charts/caddy-ingress-controller"

echo "Discovering latest Helm chart version..."

CHART_VERSION="$(
  helm show chart "${CHART}" \
    | awk -F': ' '$1 == "version" { print $2; exit }'
)"

if [[ -z "${CHART_VERSION}" ]]; then
  echo "Failed to determine latest Helm chart version"
  exit 1
fi

echo "Latest chart version: ${CHART_VERSION}"

echo "Installing/upgrading Helm chart..."

helm upgrade --install caddy-ingress \
  "${CHART}" \
  --version "${CHART_VERSION}" \
  "$@"

echo "Done."