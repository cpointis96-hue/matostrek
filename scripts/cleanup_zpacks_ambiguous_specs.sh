#!/usr/bin/env bash

set -euo pipefail

if [[ ! -f ".env" ]]; then
  echo ".env not found" >&2
  exit 1
fi

source .env

BASE_URL="${NOCODB_BASE_URL}"
BASE_ID="${NOCODB_BASE_ID}"
TOKEN="${NOCODB_API_TOKEN}"
TENTS_TABLE_ID="mhotmb11c4ge3mw"
SPECS_TABLE_ID="mumlsmxsho0do7w"

tent_id_from_slug() {
  local slug="$1"
  /usr/bin/curl -s -H "xc-token: $TOKEN" \
    "$BASE_URL/api/v1/db/data/noco/$BASE_ID/$TENTS_TABLE_ID?where=(slug,eq,$slug)&limit=1" |
    jq -r '.list[0].Id // empty'
}

delete_specs_matching_keys() {
  local tent_id="$1"
  local pattern="$2"
  local ids

  ids=$(
    /usr/bin/curl -s -H "xc-token: $TOKEN" \
      "$BASE_URL/api/v1/db/data/noco/$BASE_ID/$SPECS_TABLE_ID?where=(tent_id,eq,$tent_id)&limit=500" |
      jq -r --arg pattern "$pattern" '.list[] | select(.key | test($pattern)) | .Id'
  )

  if [[ -z "$ids" ]]; then
    return
  fi

  while IFS= read -r id; do
    /usr/bin/curl -s -X DELETE \
      -H "xc-token: $TOKEN" \
      "$BASE_URL/api/v1/db/data/noco/$BASE_ID/$SPECS_TABLE_ID/$id" >/dev/null
  done <<< "$ids"
}

altaplex_id=$(tent_id_from_slug "altaplex-tent")
duplex_id=$(tent_id_from_slug "duplex-tent")

if [[ -n "$altaplex_id" ]]; then
  delete_specs_matching_keys "$altaplex_id" '^variant_(1p|2p)_'
  echo "CLEANED altaplex-tent"
fi

if [[ -n "$duplex_id" ]]; then
  delete_specs_matching_keys "$duplex_id" '^(regular|large)_'
  echo "CLEANED duplex-tent"
fi
