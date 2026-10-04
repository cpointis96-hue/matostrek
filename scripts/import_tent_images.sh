#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="${1:-Images/Zpacks}"

if [[ ! -f ".env" ]]; then
  echo ".env not found" >&2
  exit 1
fi

source .env

BASE_URL="${NOCODB_BASE_URL}"
BASE_ID="${NOCODB_BASE_ID}"
TOKEN="${NOCODB_API_TOKEN}"
TABLE_ID="mhotmb11c4ge3mw"

ensure_attachment_column() {
  local column_name="$1"
  local title="$2"
  local attachment_count

  attachment_count=$(
    /usr/bin/curl -s -H "xc-token: $TOKEN" \
      "$BASE_URL/api/v1/db/meta/tables/$TABLE_ID" |
      jq --arg column_name "$column_name" \
        '[.columns[] | select(.uidt=="Attachment" and .column_name==$column_name)] | length'
  )

  if [[ "$attachment_count" == "0" ]]; then
    /usr/bin/curl -s -X POST \
      -H "xc-token: $TOKEN" \
      -H "Content-Type: application/json" \
      "$BASE_URL/api/v1/db/meta/tables/$TABLE_ID/columns" \
      --data "{\"title\":\"$title\",\"column_name\":\"$column_name\",\"uidt\":\"Attachment\"}" >/dev/null
  fi
}

slug_from_dir() {
  local dir_name="$1"

  case "$dir_name" in
    "Altaplex Tent - Tall 1P UL Backpacking Shelter _ Zpacks") echo "altaplex-tent" ;;
    "Duplex Lite Tent - 2P UL Backpacking Shelter _ Zpacks") echo "duplex-lite-tent" ;;
    "Duplex Pro Tent - 2p UL Backpacking Shelter _ Zpacks") echo "duplex-pro-tent" ;;
    "Duplex Tent - 2P UL Backpacking Shelter _ Zpacks") echo "duplex-tent" ;;
    "Pivot Duo Tent - 2P Ultralight Backpacking Shelter _ Zpacks") echo "pivot-duo-tent" ;;
    "Pivot Solo Tent - 1P Ultralight Backpacking Shelter _ Zpacks") echo "pivot-solo-tent" ;;
    "Pivot Trio Tent - 3P Ultralight Backpacking Shelter _ Zpacks") echo "pivot-trio-tent" ;;
    "Plex Solo Tent - 1P Ultralight Backpacking Shelter _ Zpacks") echo "plex-solo-tent" ;;
    "Triplex Pro Tent - 3p UL Backpacking Shelter _ Zpacks") echo "triplex-pro-tent" ;;
    "Ultralight 1 Person Tent _ Hexamid Solo Tent _ Zpacks") echo "hexamid-tent" ;;
    *) echo "" ;;
  esac
}

record_id_from_slug() {
  local slug="$1"
  /usr/bin/curl -s -H "xc-token: $TOKEN" \
    "$BASE_URL/api/v1/db/data/noco/$BASE_ID/$TABLE_ID?where=(slug,eq,$slug)&limit=1" |
    jq -r '.list[0].Id // empty'
}

upload_file() {
  local file_path="$1"
  /usr/bin/curl -s -X POST \
    "$BASE_URL/api/v2/storage/upload" \
    -H "xc-token: $TOKEN" \
    -F "file=@$file_path"
}

patch_images() {
  local record_id="$1"
  local attachments_json="$2"
  local hero_image_json="$3"
  local payload

  payload=$(
    jq -cn \
      --argjson images "$attachments_json" \
      --argjson hero_image "$hero_image_json" \
      '{images: $images, hero_image: $hero_image}'
  )

  /usr/bin/curl -s -X PATCH \
    -H "xc-token: $TOKEN" \
    -H "Content-Type: application/json" \
    "$BASE_URL/api/v1/db/data/noco/$BASE_ID/$TABLE_ID/$record_id" \
    --data "$payload" >/dev/null
}

ensure_attachment_column "images" "images"
ensure_attachment_column "hero_image" "hero_image"

imported=0
skipped=0

while IFS= read -r -d '' dir_path; do
  dir_name="$(basename "$dir_path")"
  slug="$(slug_from_dir "$dir_name")"

  if [[ -z "$slug" ]]; then
    echo "SKIP unmapped directory: $dir_name"
    skipped=$((skipped + 1))
    continue
  fi

  record_id="$(record_id_from_slug "$slug")"

  if [[ -z "$record_id" ]]; then
    echo "SKIP missing record for slug: $slug"
    skipped=$((skipped + 1))
    continue
  fi

  attachments='[]'
  file_count=0

  while IFS= read -r file_path; do
    if [[ "$(basename "$file_path")" == ".DS_Store" ]]; then
      continue
    fi

    upload_json="$(upload_file "$file_path")"
    upload_item="$(printf '%s' "$upload_json" | jq '.[0]')"
    attachments="$(printf '%s\n%s\n' "$attachments" "$upload_item" | jq -cs '.[0] + [.[1]]')"
    file_count=$((file_count + 1))
  done < <(/usr/bin/find "$dir_path" -maxdepth 1 -type f | /usr/bin/sort)

  if [[ "$file_count" -eq 0 ]]; then
    echo "SKIP no files: $slug"
    skipped=$((skipped + 1))
    continue
  fi

  hero_image="$(printf '%s' "$attachments" | jq '[.[0]]')"

  patch_images "$record_id" "$attachments" "$hero_image"
  echo "IMPORTED $slug ($file_count images)"
  imported=$((imported + 1))
done < <(/usr/bin/find "$ROOT_DIR" -mindepth 1 -maxdepth 1 -type d -print0 | /usr/bin/sort -z)

echo "DONE imported=$imported skipped=$skipped"
