#!/bin/bash
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

if [[ -z "${NAMESPACE:-}" ]]; then
  echo "ERROR: NAMESPACE is not set"
  exit 1
fi

if [[ -z "${APP_INSTANCE_NAME:-}" ]]; then
  echo "ERROR: APP_INSTANCE_NAME is not set"
  exit 1
fi

exec /testrunner \
  -logtostderr \
  --test_spec=/tests/basic-suite.yaml