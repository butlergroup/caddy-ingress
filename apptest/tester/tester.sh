#!/usr/bin/env bash
#
# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -euo pipefail

echo "Starting Caddy ingress Marketplace tester"
echo "NAMESPACE=${NAMESPACE:-}"
echo "APP_INSTANCE_NAME=${APP_INSTANCE_NAME:-}"

dump_debug() {
  echo "========== DEBUG: namespace =========="
  kubectl get namespace "${NAMESPACE}" -o yaml || true

  echo "========== DEBUG: service account =========="
  kubectl get sa "${APP_INSTANCE_NAME}-deployer-sa" -n "${NAMESPACE}" -o yaml || true

  echo "========== DEBUG: auth can-i =========="
  kubectl auth can-i get pods -n "${NAMESPACE}" || true
  kubectl auth can-i get pods/log -n "${NAMESPACE}" || true
  kubectl auth can-i create pods -n "${NAMESPACE}" || true
  kubectl auth can-i delete pods -n "${NAMESPACE}" || true
  kubectl auth can-i get services -n "${NAMESPACE}" || true
  kubectl auth can-i create services -n "${NAMESPACE}" || true
  kubectl auth can-i create deployments.apps -n "${NAMESPACE}" || true
  kubectl auth can-i create ingresses.networking.k8s.io -n "${NAMESPACE}" || true

  echo "========== DEBUG: resources =========="
  kubectl get all -n "${NAMESPACE}" -o wide || true
  kubectl get ingress -n "${NAMESPACE}" -o wide || true
  kubectl get events -n "${NAMESPACE}" --sort-by=.lastTimestamp || true

  echo "========== DEBUG: controller logs =========="
  kubectl logs -n "${NAMESPACE}" -l app.kubernetes.io/instance="${APP_INSTANCE_NAME}" --tail=300 || true
}

trap dump_debug EXIT

exec /testrunner \
  -logtostderr \
  --test_spec=/tests/basic-suite.yaml