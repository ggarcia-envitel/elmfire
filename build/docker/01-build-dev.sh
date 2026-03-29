#!/usr/bin/env bash
# Build the elmfire-dev image (adds Python venv on top of elmfire:<version>).
#
# Usage:
#   bash 01-build-dev.sh
#   ELMFIRE_VER=2025.1002 bash 01-build-dev.sh
#
# Prerequisites:
#   - elmfire:<ELMFIRE_VER> base image must already exist.
#     Build it first with: bash 01-build.sh
#   - riskmap-resolver repo must be at ../../riskmap-resolver relative to this
#     script (i.e. riskmap/riskmap-resolver/).  Override with RESOLVER_DIR.
set -euo pipefail

ELMFIRE_VER="${ELMFIRE_VER:-2025.1002}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKSPACE_ROOT="$(cd "${SCRIPT_DIR}/../../../.." && pwd)"
RESOLVER_DIR="${RESOLVER_DIR:-${WORKSPACE_ROOT}/riskmap-resolver}"

if [[ ! -d "${RESOLVER_DIR}" ]]; then
    echo "ERROR: riskmap-resolver not found at ${RESOLVER_DIR}" >&2
    echo "       Set RESOLVER_DIR=/path/to/riskmap-resolver or clone the repo there." >&2
    exit 1
fi

# Build in a temporary context so we can include the resolver source
# without polluting the elmfire repo's working tree.
TMPCTX="$(mktemp -d)"
trap 'rm -rf "${TMPCTX}"' EXIT

cp -r "${SCRIPT_DIR}/." "${TMPCTX}/"
cp -r "${RESOLVER_DIR}" "${TMPCTX}/riskmap-resolver"

docker build \
    --build-arg ELMFIRE_VER="${ELMFIRE_VER}" \
    -f "${TMPCTX}/Dockerfile.dev" \
    -t "elmfire-dev:${ELMFIRE_VER}" \
    "${TMPCTX}"

echo "Built elmfire-dev:${ELMFIRE_VER}"
