#!/usr/bin/env bash

# Exit on error
set -eo pipefail

: ${NEXUS_BASE_URL?"NEXUS_BASE_URL must be provided for nexus provider"}
: ${NEXUS_REPOSITORY?"NEXUS_REPOSITORY must be provided for nexus provider"}

# Allow credentials to come from MI_REPOSITORY_* or NEXUS_*
NEXUS_USERNAME_EFFECTIVE="${MI_REPOSITORY_USERNAME:-${NEXUS_USERNAME}}"
NEXUS_PASSWORD_EFFECTIVE="${MI_REPOSITORY_PASSWORD:-${NEXUS_PASSWORD}}"

: ${NEXUS_USERNAME_EFFECTIVE?"MI_REPOSITORY_USERNAME or NEXUS_USERNAME must be provided for nexus provider"}
: ${NEXUS_PASSWORD_EFFECTIVE?"MI_REPOSITORY_PASSWORD or NEXUS_PASSWORD must be provided for nexus provider"}

# provider_get_checksum <relative_path>
provider_get_checksum() {
  local path="$1"
  local url="${NEXUS_BASE_URL}/service/rest/v1/search?repository=${NEXUS_REPOSITORY}&name=/${path}"
  curl -s -u "${NEXUS_USERNAME_EFFECTIVE}:${NEXUS_PASSWORD_EFFECTIVE}" -X GET "${url}" | jq -r '.items[0].assets[0].checksum.md5'
}

# provider_download <relative_path> <dest_file>
provider_download() {
  local path="$1"
  local dest_file="$2"
  wget -O "${dest_file}" --no-verbose --user="${NEXUS_USERNAME_EFFECTIVE}" --password="${NEXUS_PASSWORD_EFFECTIVE}" "${NEXUS_BASE_URL}/repository/${NEXUS_REPOSITORY}/${path}"
}


