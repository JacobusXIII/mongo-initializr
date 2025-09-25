#!/usr/bin/env bash

# Exit on error
set -eo pipefail

# Provider abstraction for fetching/syncing dbdata-files.
# Supported providers: nexus (default)

PROVIDER_NAME="${PROVIDER_NAME:-nexus}"

# Resolve this script directory to locate providers
_THIS_FILE_DIR=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")
_PROVIDERS_DIR="${_THIS_FILE_DIR}/providers"

# Source provider implementation
if [[ -f "${_PROVIDERS_DIR}/${PROVIDER_NAME}.sh" ]]; then
  source "${_PROVIDERS_DIR}/${PROVIDER_NAME}.sh"
else
  echo "Unsupported provider: ${PROVIDER_NAME}" >&2
  exit 2
fi
