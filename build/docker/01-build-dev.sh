#!/usr/bin/env bash
# Build the elmfire-dev image (adds Python venv on top of elmfire:<version>).
#
# Usage:
#   bash 01-build-dev.sh
#   ELMFIRE_VER=2025.1002 bash 01-build-dev.sh
#
# Prerequisites: elmfire:<ELMFIRE_VER> base image must already exist.
#   Build it first with: bash 01-build.sh
set -euo pipefail

ELMFIRE_VER="${ELMFIRE_VER:-2025.1002}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

docker build \
    --build-arg ELMFIRE_VER="${ELMFIRE_VER}" \
    -f "${SCRIPT_DIR}/Dockerfile.dev" \
    -t "elmfire-dev:${ELMFIRE_VER}" \
    "${SCRIPT_DIR}"

echo "Built elmfire-dev:${ELMFIRE_VER}"
